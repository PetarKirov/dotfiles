#!/usr/bin/env bash

set -euo pipefail

DISK_ID="${DISK_ID:-${1:-}}"
ESP_SIZE_GiB="${ESP_SIZE_GiB:-4}"
SWAP_SIZE_GiB="${SWAP_SIZE_GiB:-16}"

DRY_RUN="${DRY_RUN:-true}"
KEEP_PARTITIONS="${KEEP_PARTITIONS:-true}"

red=$(tput -T ansi setaf 1)
no_fg_color=$(tput -T ansi setaf 9)
no_bg_color=$(tput -T ansi setab 9)
no_color="${no_fg_color}${no_bg_color}"
bold=$(tput -T ansi bold)
offbold=$'\E[22m'
normal=$(tput -T ansi sgr0)

function main {
  print_devices

  prompt "Please enter block device id path you want to operate on:"
  DISK_ID="$REPLY"
  while [[ "${DISK_ID}" != /dev/disk/by-id/* ]]; do
    echo "Expected path to start with '${bold}/dev/disk/by-id/${offbold}'"
    echo "Got: '$DISK_ID'"
    echo "Try again:"
    prompt "Please enter the block device you want to operate on:"
  done
  DISK_ID_ONLY="${DISK_ID##/dev/disk/by-id/}"

  if [[ "${DISK_ID}" == *-part* ]]; then
    echo "Expected \$DISK_ID to identify a whole disk (storage device), not a partition"
    echo "(\$DISK_ID='$DISK_ID')"
    exit 1
  fi

  test -b "$DISK_ID" || log_error "'$DISK_ID' does not exist or is not a block device"

  DEV="$(readlink -f "$DISK_ID")"
  DEV_NAME="${DEV##/dev/}"
  DEV_SECTORS="$(cat "/sys/block/${DEV_NAME}"/size)"
  DEV_SECTOR_SIZE="$(cat "/sys/block/${DEV_NAME}"/queue/hw_sector_size)"
  DEV_SIZE="$(( DEV_SECTORS * DEV_SECTOR_SIZE ))"

  FS_TYPE_ESP="ef00"
  FS_TYPE_SWAP="8200"
  FS_TYPE_ROOT="bf00"

  KiB=1024
  MiB=$((1024 * KiB))
  GiB=$((1024 * MiB))

  ALIGN=${MiB}

  DEV_SIZE_A=$(( DEV_SIZE / ALIGN ))

  draw_box "Info" << EOF
Device: '${bold}${DEV}${offbold}'
ID: '${bold}${DISK_ID_ONLY}${offbold}'
Size: $(format_size "$DEV_SIZE") ($DEV_SIZE bytes)
Sector size: $(format_size "$DEV_SECTOR_SIZE") ($DEV_SECTOR_SIZE bytes)
Alignment: $(format_size "$ALIGN") ($ALIGN bytes)
EOF
  ESP_SIZE=$(( ESP_SIZE_GiB * GiB ))
  ESP_START="$(( 1 * ALIGN ))"
  ESP_END="$(( ESP_START + ESP_SIZE - DEV_SECTOR_SIZE ))"
  ESP_START_S="$(( ESP_START / DEV_SECTOR_SIZE ))"
  ESP_END_S="$(( ESP_END / DEV_SECTOR_SIZE ))"

  SWAP_SIZE=$(( SWAP_SIZE_GiB * GiB ))
  SWAP_SIZE_A=$(( SWAP_SIZE / ALIGN ))

  SWAP_START="$(( (DEV_SIZE_A - SWAP_SIZE_A) * ALIGN ))"
  SWAP_END="$(( SWAP_START + SWAP_SIZE - DEV_SECTOR_SIZE ))"
  SWAP_START_S="$(( SWAP_START / DEV_SECTOR_SIZE ))"
  SWAP_END_S="$(( SWAP_END / DEV_SECTOR_SIZE ))"

  ROOT_START="$(( ESP_END + DEV_SECTOR_SIZE ))"
  ROOT_END="$(( SWAP_START - DEV_SECTOR_SIZE ))"
  ROOT_START_S="$(( ROOT_START / DEV_SECTOR_SIZE ))"
  ROOT_END_S="$(( ROOT_END / DEV_SECTOR_SIZE ))"

  if [[ "$KEEP_PARTITIONS" == "true" ]]; then
    print_one_device "$DISK_ID" | draw_box "The following partitions will be kept:"
  else
    {
      print_partition_layout "ESP" "$ESP_START" "$ESP_END"
      print_partition_layout "ROOT" "$ROOT_START" "$ROOT_END"
      print_partition_layout "SWAP" "$SWAP_START" "$SWAP_END"
    } | draw_box "The following partitions will be created:" false
  fi


  ESP_PART_NUM=1
  ROOT_PART_NUM=2
  SWAP_PART_NUM=3

  [[ "$KEEP_PARTITIONS" != "true" ]] && {
    confirm
    force_create_gpt
    add_gpt_partition $ESP_PART_NUM "$ESP_START_S" "$ESP_END_S" "$FS_TYPE_ESP" "esp"
    add_gpt_partition $ROOT_PART_NUM "$ROOT_START_S" "$ROOT_END_S" "$FS_TYPE_ROOT" "zfs_root"
    add_gpt_partition $SWAP_PART_NUM "$SWAP_START_S" "$SWAP_END_S" "$FS_TYPE_SWAP" "swap"
    print_gpt_partition_info
  } | draw_box "Partitioning '$DISK_ID'"

  local esp_partition
  esp_partition="$(partition_id "$ESP_PART_NUM")"

  local zfs_pool_name=zfs_root

  if check_zfs_pool "$zfs_pool_name"; then
    print_zfs_info | draw_box "A pool named '${zfs_pool_name}' already exists:"
    confirm "Are you sure you want to destroy it and create a new one? (yes/no)"
    run_cmd sudo umount -R /mnt || true
    run_cmd sudo zpool destroy zfs_root
  fi

  {
    create_single_disk_zfs_root_fs "$zfs_pool_name" $ROOT_PART_NUM
    create_zfs_datasets "$zfs_pool_name" "$esp_partition"
    DRY_RUN=0
    print_zfs_info
  } | draw_box "Creating zpool and zfs datasets"

  {
    run_cmd sudo mkdir -p /mnt/boot
    run_cmd sudo mount "$esp_partition" /mnt/boot
  } | draw_box "Mounting file systems"
}

function partition_id {
  echo "${DISK_ID}-part${1}"
}

function check_partition {
  local id="$1"
  local i=0
  local realdev_partition
  realdev_partition="$(readlink -f "$id")"
  while ! ls -la "$id" >/dev/null 2>&1 || ! [ -b "$realdev_partition" ]; do
    if (( i > 10 )); then
      break
    fi
    run_cmd udevadm settle --timeout=15 --exit-if-exists="$realdev_partition"
    sudo blockdev --rereadpt "$DISK_ID" || true
    i=$(( i + 1))
    sleep 1
  done
  test -e "$id" || log_error "'$id' does not exist"
  test -b "$id" || log_error "'$id' is not a block device"
}

function force_create_gpt {
  run_cmd sudo blkdiscard -f "$DEV"
  run_cmd sudo sgdisk --zap-all "$DEV"
}

function add_gpt_partition {
  local partnum="$1"
  local start="$2"
  local end="$3"
  local type="$4"
  local name="$5"

  run_cmd sudo sgdisk \
    "-n${partnum}:${start}:${end}" \
    "-t${partnum}:${type}" \
    "-c${partnum}:${name}" "$DEV"

  local parition_id
  parition_id="$(partition_id "$1")"
  check_partition "$parition_id"

  case "$name" in
    swap)
      run_cmd sudo mkswap -L swap "$parition_id"
      ;;

    esp)
      run_cmd sudo mkfs.fat -F 32 -n EFI "$parition_id"
      ;;

    *)
      return
      ;;
  esac
}

function get_block_device_ids {
  for kname in $(lsblk -dn -o kname); do
    local path
    if [[ -e "/sys/block/$kname/wwid" ]]; then
      path="/sys/block/$kname/wwid"
    elif [[ -e "/sys/block/$kname/device/wwid" ]]; then
      path="/sys/block/$kname/device/wwid"
    fi
    if [[ "${path:-}" == '' ]] || ! cat "$path" >/dev/null 2>&1; then
      continue;
    fi
    kindof_id="$(cat "$path")"
    kindof_id="${kindof_id##*.}"
    find /dev/disk/by-id/ -lname "*/$kname" | grep -Pv "^/dev/disk/by-id/.*${kindof_id}$"
  done
}

function print_devices {
  for device_id_path in $(get_block_device_ids); do
    print_one_device "$device_id_path" | draw_box "$device_id_path"
  done
}

function print_one_device {
  lsblk -o tran,name,size,fstype,mountpoints,label,partlabel,serial "$1"
}

function create_single_disk_zfs_root_fs {
  local pool_name="$1"
  local part_num="$2"
  local partition_id
  partition_id="$(partition_id "$part_num")"

  # ashift: https://openzfs.github.io/openzfs-docs/man/7/zpoolprops.7.html#:~:text=command%3A-,ashift,-%3D
  # autotrim: https://openzfs.github.io/openzfs-docs/man/7/zpoolprops.7.html#:~:text=for%20more%20details.-,autotrim,-%3D
  # listsnapshots: https://openzfs.github.io/openzfs-docs/man/7/zpoolprops.7.html#:~:text=on%20feature%20states.-,listsnapshots,-%3D
  # atime: https://openzfs.github.io/openzfs-docs/man/7/zfsprops.7.html#:~:text=for%20more%20details.-,atime,-%3D
  # mountpoint: https://openzfs.github.io/openzfs-docs/man/7/zfsprops.7.html#:~:text=mountpoint%3Dpath%7Cnone%7Clegacy
  # acltype: https://openzfs.github.io/openzfs-docs/man/7/zfsprops.7.html#:~:text=acltype%3Doff%7Cnfsv4%7Cposix
  # xattr: https://openzfs.github.io/openzfs-docs/man/7/zfsprops.7.html#:~:text=used%20by%20OpenZFS.-,xattr,-%3D

  run_cmd sudo zpool create \
    -R /mnt \
    -o ashift=12 \
    -o autotrim=on \
    -o listsnapshots=on \
    -O acltype=posixacl \
    -O atime=off \
    -O canmount=off \
    -O mountpoint=none \
    -O checksum=sha512 \
    -O compression=lz4 \
    -O xattr=sa \
    "$pool_name" \
    "$partition_id"
}

function check_zfs_pool {
  local pool_name="$1"
  zpool status "$pool_name" >/dev/null 2>&1
}

function create_zfs_datasets {
  local pool_name="$1"
  local esp_partition="$2"

  # Root
  run_cmd sudo zfs create "$pool_name/nixos" -o mountpoint=/ -o canmount=on

  # Reserved
  run_cmd sudo zfs create "$pool_name/reserved" -o mountpoint=none -o refreservation=5G

  # Nix Store
  run_cmd sudo zfs create "$pool_name/nixos/nix" -o canmount=on -o refreservation=50G

  # Docker
  run_cmd sudo zfs create "$pool_name/nixos/var" -o canmount=on
  run_cmd sudo zfs create "$pool_name/nixos/var/lib" -o canmount=on
  run_cmd sudo zfs create "$pool_name/nixos/var/lib/docker" -o canmount=on -o quota=75G

  # Home
  run_cmd sudo zfs create "$pool_name/userdata" -o canmount=off -o mountpoint=/
  run_cmd sudo zfs create "$pool_name/userdata/home" -o canmount=on -o refreservation=75G -o reservation=150G
}

function print_zfs_info {
  run_cmd sudo zpool status
  run_cmd sudo zfs list -r
}

function print_gpt_partition_info {
  run_cmd sudo sgdisk -p "$DEV"
  run_cmd sudo parted "$DEV" -- unit MiB print free
  ls -la '/dev/disk/by-id/' | grep "$DISK_ID_ONLY" | draw_box "Disk IDs"
}

function run_cmd {
  local cmd
  cmd="${bold}$(echo "$*" | fmt -s -w 80 | draw_box "")${offbold}"
  cmd="$(echo "$cmd" | sed -e '$ ! s/^/    /' -e '$ s/^./╭─➤─┴/')"
  echo "${cmd}"
  if [[ "$DRY_RUN" != 'true' ]]; then
    set +e
    exec "$@" 2>&1 | \
      sed -e 's/^/│ /' -e $'s/\t/    /'
    local rc=$?
    set -e
    if [ $rc -eq 0 ]; then
      echo "╰── [OK] ──╯"
    else
      echo "╰── ${red}[ERROR]${no_color} ──╯"
      return $rc
    fi
  else
    echo "╰── [DRY RUN] ──╯"
  fi
}

function print_partition_layout {
  local name="$1"
  local start="$2"
  local end="$3"
  local size="$(( end - start ))"
  local size_share
  size_share="$(awk "BEGIN { printf(\"%.2f\", 100.0 * $size / $DEV_SIZE) }")"

  name_len="${#name}"
  name="${bold}${name}${offbold}"
  local line
  line="$(draw_line "$(( name_len ))")"

  echo "│ ╭─${line}─╮"
  echo "├─┤ ${name} │ size: $(format_size "$size") (${size} bytes / ${size_share}%)"
  echo "│ ╰─┬${line}╯"
  echo "│   ├${line} start: $(format_size "$start") (${start} bytes / $(( start / DEV_SECTOR_SIZE )) sectors)"
  echo "│   └${line}   end: $(format_size "$end") (${end} bytes / $(( end / DEV_SECTOR_SIZE )) sectors)"
}

function prompt {
  local msg="$1"
  local end=$'\n╰─➤ '
  read -p "╭── ${msg}${end}" -r
}

# shellcheck disable=SC2120
function confirm {
  local default_msg="Are you sure you wish to continue? (yes/no)"
  prompt "${1:-$default_msg}"
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    exit 0
  fi
}

function log_error {
  local rc="$?"
  echo "$red"
  echo "$1" | draw_box "Error (exit code: $rc)" yes "$no_color"
  return $rc
}

function format_size {
  echo "${bold}$(numfmt --to=iec-i --suffix=B --round=nearest -- "$1")${normal}"
}

function draw_line {
  repeatStr "$1" "─"
}

function repeatStr {
  local len="$1"
  local str="$2"
  printf "%${len}s" | sed "s/ /${str}/g"
}

function remove_ansi_escapes {
  sed -r "s/\x1b\[([0-9]{1,2}(;[0-9]{1,2})*)?[m|K]//g"
}

function draw_box {
  local title="$1"
  local draw_left_box_side="${2:-}"
  local reset_esc_seq="${3:-}"
  local title_len=${#title}
  title="${bold}${title}${offbold}"

  local output
  output="$(cat)"

  local output_width
  output_width="$(echo "$output" | remove_ansi_escapes | wc -L)"

  local prefix
  if [[ "$draw_left_box_side" != false ]]; then
    prefix='│ '
  else
    prefix=''
  fi

  prefix_len="${#prefix}"

  local inner_width
  if (( title_len > 0 )); then
    top_border_len=$(( output_width + prefix_len - title_len - 7 ))
    if (( top_border_len <= 0)); then
      top_border_len=0
      top_border=""
    else
      top_border="$(draw_line "$top_border_len")"
    fi
    inner_width=$(( 3 + title_len + 2 + top_border_len ))
    echo "╭──╼ ${title} ╾${top_border}─╮"
  else
    top_border="$(draw_line $(( output_width + prefix_len - 3 )))"
    inner_width=$(( 1 + ${#top_border} ))
    echo "╭──${top_border}─╮"
  fi

  local bottom_border
  bottom_border="$(draw_line $inner_width)"

  output_width=$(( inner_width - (prefix_len - 2) ))

  while IFS="" read -r line
  do
    local line_length
    line_length="$(echo "$line" | remove_ansi_escapes | wc -L)"

    local rightPadLen=$(( output_width - line_length))
    local rightPad
    rightPad="$(repeatStr "$rightPadLen" ' ')"

    printf '%s%s%s │\n' "$prefix" "$line" "$rightPad"
  done <<< "$output"

  echo "╰─${bottom_border}─╯${reset_esc_seq}"
}

main
