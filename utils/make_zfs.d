#!/usr/bin/env -S dmd -run

import std.conv : to;
import std.format : fmt = format;

struct UiConfig
{
    bool interactive = true;
    bool dryRun = true;
    bool keepPartitions = true;
}

struct DevicePartitionConfig
{
    ulong espSize = 4.GiB;
    ulong swapSize = 16.GiB;
    ulong alignment = 1.MiB;
    string primaryDevicePath;
    string[] additionalDevicePaths;
    string[] zfsDatasets;
}

//DISK_ID="${DISK_ID:-${1:-}}"

void main(string[] args)
{
    Context ctx = new Context();
    printDevices(ctx);

    string primaryDevice;
}


/+
  while ()
  prompt(
    "Please enter block device id path you want to operate on:"
  );
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
    recreateGptPartitionTable
    addGptPartition $ESP_PART_NUM "$ESP_START_S" "$ESP_END_S" "$FS_TYPE_ESP" "esp"
    addGptPartition $ROOT_PART_NUM "$ROOT_START_S" "$ROOT_END_S" "$FS_TYPE_ROOT" "zfs_root"
    addGptPartition $SWAP_PART_NUM "$SWAP_START_S" "$SWAP_END_S" "$FS_TYPE_SWAP" "swap"
    printGptPartitionInfo
  } | draw_box "Partitioning '$DISK_ID'"

  local esp_partition
  esp_partition="$(partition_id "$ESP_PART_NUM")"

  local zfs_pool_name=zfs_root

  if check_zfs_pool "$zfs_pool_name"; then
    printZfsInfo | draw_box "A pool named '${zfs_pool_name}' already exists:"
    confirm "Are you sure you want to destroy it and create a new one? (yes/no)"
    run_cmd sudo umount -R /mnt || true
    run_cmd sudo zpool destroy zfs_root
  fi

  {
    create_single_disk_zfs_root_fs "$zfs_pool_name" $ROOT_PART_NUM
    create_zfs_datasets "$zfs_pool_name" "$esp_partition"
    DRY_RUN=0
    printZfsInfo
  } | draw_box "Creating zpool and zfs datasets"

  {
    run_cmd sudo mkdir -p /mnt/boot
    run_cmd sudo mount "$esp_partition" /mnt/boot
  } | draw_box "Mounting file systems"
}
+/

string partition_id(string devicePath, uint partNum) {
    return "%s-part%s".fmt(devicePath, partNum);
}

void checkPartition(Context ctx, string partitionPath) {
    /+
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
    +/
}

void recreateGptPartitionTable(Context ctx, string devicePath) {
  `blkdiscard -f "%s"`.runSudoCommand(ctx, devicePath);
  `sgdisk --zap-all "%s"`.runSudoCommand(ctx, devicePath);
}

void addGptPartition(
    Context ctx,
    string devicePath,
    uint partnum,
    ulong start,
    ulong end,
    PartitionType type,
    string name)
{
    (`sgdisk ` ~
        `-n${partnum}:${start}:${end} ` ~
        `-t${partnum}:${type} ` ~
        `-c${partnum}:${name} "$DEV"`)
        .runSudoCommand([
            "partnum": partnum.to!string,
            "start": start.to!string,
            "end": end.to!string,
            "type": type,
            "dev": devicePath
        ]);

    string partitionPath = partition_id(devicePath, partnum);
    checkPartition(ctx, partitionPath);

    final switch (name)
    {
        case "swap":
            `mkswap -L swap '%s'`.runSudoCommand(partitionPath);
            break;
        case "esp":
            `mkfs.fat -F 32 -n EFI '%s'`.runSudoCommand(partitionPath);
            break;
    }
}

string[] get_block_device_ids(Context ctx)
{
    assert(0, "Not implemented");
    foreach (kname; "lsblk -dn -o kname".runCommandGetOutput(ctx).byLine)
    {
    // local path
    // if [[ -e "/sys/block/$kname/wwid" ]]; then
    //   path="/sys/block/$kname/wwid"
    // elif [[ -e "/sys/block/$kname/device/wwid" ]]; then
    //   path="/sys/block/$kname/device/wwid"
    // fi
    // if [[ "${path:-}" == '' ]] || ! cat "$path" >/dev/null 2>&1; then
    //   continue;
    // fi
    // kindof_id="$(cat "$path")"
    // kindof_id="${kindof_id##*.}"
    // find /dev/disk/by-id/ -lname "*/$kname" | grep -Pv "^/dev/disk/by-id/.*${kindof_id}$"
    }
}

void printDevices(Context ctx) {
    foreach (devicePath; get_block_device_ids(ctx))
        ctx.drawBox(devicePath, delegate void(Context ctx) { print_one_device(ctx, devicePath); });
}

string print_one_device(Context ctx, string devicePath) {
    return `lsblk -o tran,name,size,fstype,mountpoints,label,partlabel,serial "%s"`
        .runCommandGetOutput(ctx, devicePath);
}

void create_single_disk_zfs_root_fs(
    Context ctx,
    string partitionPath,
    string poolName,
)
{
    /*
    ashift: https://openzfs.github.io/openzfs-docs/man/7/zpoolprops.7.html#:~:text=command%3A-,ashift,-%3D
    autotrim: https://openzfs.github.io/openzfs-docs/man/7/zpoolprops.7.html#:~:text=for%20more%20details.-,autotrim,-%3D
    listsnapshots: https://openzfs.github.io/openzfs-docs/man/7/zpoolprops.7.html#:~:text=on%20feature%20states.-,listsnapshots,-%3D
    atime: https://openzfs.github.io/openzfs-docs/man/7/zfsprops.7.html#:~:text=for%20more%20details.-,atime,-%3D
    mountpoint: https://openzfs.github.io/openzfs-docs/man/7/zfsprops.7.html#:~:text=mountpoint%3Dpath%7Cnone%7Clegacy
    acltype: https://openzfs.github.io/openzfs-docs/man/7/zfsprops.7.html#:~:text=acltype%3Doff%7Cnfsv4%7Cposix
    xattr: https://openzfs.github.io/openzfs-docs/man/7/zfsprops.7.html#:~:text=used%20by%20OpenZFS.-,xattr,-%3D
    */

  (`zpool create` ~
    `-R /mnt` ~
    `-o ashift=12` ~
    `-o autotrim=on` ~
    `-o listsnapshots=on` ~
    `-O acltype=posixacl` ~
    `-O atime=off` ~
    `-O canmount=off` ~
    `-O mountpoint=none` ~
    `-O checksum=sha512` ~
    `-O compression=lz4` ~
    `-O xattr=sa` ~
    `"%s"` ~
    `"%s"`)
    .runSudoCommand(ctx, poolName, partitionPath);
}

void check_zfs_pool(string poolName) {
  `zpool status`.runCommandSilently(poolName);
}

void create_zfs_datasets(Context ctx, string poolName, ZfsDataset[] datasets) {

    foreach (dataset; datasets)
    {
        `zfs create "%s/%s"`
            .opts(dataset.options)
            .runSudoCommand(ctx, poolName, dataset.name);
    }

//   # Root
//   run_cmd sudo zfs create "$pool_name/nixos" -o mountpoint=/ -o canmount=on

//   # Reserved
//   run_cmd sudo zfs create "$pool_name/reserved" -o mountpoint=none -o refreservation=5G

//   # Nix Store
//   run_cmd sudo zfs create "$pool_name/nixos/nix" -o canmount=on -o refreservation=50G

//   # Docker
//   run_cmd sudo zfs create "$pool_name/nixos/var" -o canmount=on
//   run_cmd sudo zfs create "$pool_name/nixos/var/lib" -o canmount=on
//   run_cmd sudo zfs create "$pool_name/nixos/var/lib/docker" -o canmount=on -o quota=75G

//   # Home
//   run_cmd sudo zfs create "$pool_name/userdata" -o canmount=off -o mountpoint=/
//   run_cmd sudo zfs create "$pool_name/userdata/home" -o canmount=on -o refreservation=75G -o reservation=150G
}

void printZfsInfo(Context ctx) {
    `zpool status`.runSudoCommand(ctx);
    `zfs list -r`.runSudoCommand(ctx);
}

void printGptPartitionInfo(Context ctx, string devicePath, string diskId) {
    `sgdisk -p "%s"`.runSudoCommand(ctx, devicePath);
    `parted "%s" -- unit MiB print free`.runSudoCommand(ctx, devicePath);
    ctx.drawBox("Disk IDs", ctx =>
        `ls -la '/dev/disk/by-id/' | grep "%s"`.runCommand(ctx, diskId)
    );
}

/+
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
+/

void print_partition_layout(
    string name,
    ulong deviceSize,
    ulong start,
    ulong end,
)
in (start < end)
{
    const size = end - start;
    string size_share = fmt!"%.2f"(double(size) / deviceSize);

    name = TermAnsiEscSeq.bold ~ name ~ TermAnsiEscSeq.noBold;
    string line = horizontalLine(name.length);

    `
    │ ╭─${line}─╮"
    ├─┤ ${name} │ size: $(format_size "$size") (${size} bytes / ${size_share}%)"
    │ ╰─┬${line}╯"
    │   ├${line} start: $(format_size "$start") (${start} bytes / $(( start / DEV_SECTOR_SIZE )) sectors)"
    │   └${line}   end: $(format_size "$end") (${end} bytes / $(( end / DEV_SECTOR_SIZE )) sectors)"
    `.fmt();
}

string prompt(string msg)
{
    import std.stdio : write, writefln, stdout, readln;
    import std.string : strip;
    "╭── %s".writefln(msg);
    "╰─➤ ".write;
    stdout.flush();
    return readln().strip;
}

void confirm(string promptMsg = "Are you sure you wish to continue? (yes/no)") {
    import std.algorithm : among;
    import std.string : toLower;
    import core.stdc.stdlib : exit;
    const reply = prompt(promptMsg);
    if (!reply.toLower.among("y", "yes"))
        exit(1);
}

/+
function log_error {
  local rc="$?"
  echo "$red"
  echo "$1" | draw_box "Error (exit code: $rc)" yes "$no_color"
  return $rc
}
+/

string format_size(ulong size) {
  return TermAnsiEscSeq.bold ~
    `numfmt --to=iec-i --suffix=B --round=nearest -- %s`
        .runCommandGetOutput(size) ~
    TermAnsiEscSeq.normal;
}

string horizontalLine(size_t length)
{
    return repeatStr(length, "─");
}

string repeatStr(size_t length, string str)
{
    import std.range : repeat;
    return str.repeat(length).to!string;
}

string remove_ansi_escapes(string input)
{
    import std.regex;
    auto re = regex("\x1b\\[([0-9]{1,2}(;[0-9]{1,2})*)?[m|K]", "g");
    return input.replaceAll(re);
}

/+
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
      top_border="$(horizontalLine "$top_border_len")"
    fi
    inner_width=$(( 3 + title_len + 2 + top_border_len ))
    echo "╭──╼ ${title} ╾${top_border}─╮"
  else
    top_border="$(horizontalLine $(( output_width + prefix_len - 3 )))"
    inner_width=$(( 1 + ${#top_border} ))
    echo "╭──${top_border}─╮"
  fi

  local bottom_border
  bottom_border="$(horizontalLine $inner_width)"

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
+/

string opts(string cmdLine, string[string] opts)
{
    assert(0, "Not implemented");
}

void runSudoCommand(Args...)(Args args)
{
    assert(0, "Not implemented");
}

void runCommand(Args...)(Args args)
{
    assert(0, "Not implemented");
}

void runCommandSilently(Args...)(Args args)
{
    assert(0, "Not implemented");
}

string runCommandGetOutput(string cmd, Context ctx, string[] args...)
{
    assert(0, "Not implemented");
}

string captureOutput(string cmd, string[] args...)
{
    assert(0, "Not implemented");
}

string replaceVars(string format, string[string] vars)
{
    string getVar(string name)
    {
        if (auto p = name in vars)
            return *p;
        assert(0, "variable `" ~ name ~
            "` not found, used in format string `" ~ format ~ "`.");
    }
    return format.expandVars!getVar;
}

string replaceVars(Vars...)(string format)
{
    string[string] vars;
    static foreach (var; Vars)
        vars[var.stringof] = var;

    return replaceVars(format, vars);
}

unittest
{
    const cmd = "sgdisk";
    const device = "/dev/disk/by-partuuid";
    const name = "zeus";
    const id = "5";

    const fmtString = "executing `$cmd '$device/${name}_${id}'`";
    const expectedResult = "executing `sgdisk '/dev/disk/by-partuuid/zeus_5'`";

    assert(
        fmtString.replaceVars!(cmd, device, name, id) ==
        expectedResult
    );

    // order of passed arguments doesn't matter
    assert(
        fmtString.replaceVars!(id, name, cmd, device) ==
        expectedResult
    );
}

enum PartitionType
{
  esp = "ef00",
  swap = "8200",
  zfs_root = "bf00",
}

enum Units
{
    KiB = 1L << 10,
    MiB = 1L << 20,
    GiB = 1L << 30,
    TiB = 1L << 40,
}


ulong MiB(uint mebibytes)
{
    return mebibytes * Units.MiB;
}

ulong GiB(uint gibibytes)
{
    return gibibytes * Units.GiB;
}

enum TermAnsiEscSeq
{
    normal = "\x1b[0m",
    bold = "\x1b[1m",
    noBold = "\x1b[22m",
    noFgColor = "\x1b[39m",
    noBgColor = "\x1b[49m",
    noColor = TermAnsiEscSeq.noFgColor ~ TermAnsiEscSeq.noBgColor,
    red = "\x1b[31m",
}

struct ZfsDataset
{
    string name;
    string[string] options;
}

class Context
{

}

void drawBox(Context ctx, string label, void delegate(Context ctx) callback)
{

}

string[] byLine(string s)
{
    assert(0, "Not implemented");
}

/// Expand variables using `$VAR_NAME` or `${VAR_NAME}` syntax.
/// `$$` escapes itself and is expanded to a single `$`.
/// Credit: https://github.com/dlang/dub/pull/1641
private string expandVars(alias expandVar)(string s)
{
    import std.array : appender;
    import std.algorithm : countUntil;
    import std.functional : not;
    import std.exception : enforce;
    import std.string : indexOf, representation;

	auto result = appender!string;

	static bool isVarChar(char c)
	{
		import std.ascii : isAlphaNum;
		return isAlphaNum(c) || c == '_';
	}

	while (true)
	{
		auto pos = s.indexOf('$');
		if (pos < 0)
		{
			result.put(s);
			return result.data;
		}
		result.put(s[0 .. pos]);
		s = s[pos + 1 .. $];
		enforce(s.length > 0, "Variable name expected at end of string");
		switch (s[0])
		{
			case '$':
				result.put("$");
				s = s[1 .. $];
				break;
			case '{':
				pos = s.indexOf('}');
				enforce(pos >= 0, "Could not find '}' to match '${'");
				result.put(expandVar(s[1 .. pos]));
				s = s[pos + 1 .. $];
				break;
			default:
				pos = s.representation.countUntil!(not!isVarChar);
				if (pos < 0)
					pos = s.length;
				result.put(expandVar(s[0 .. pos]));
				s = s[pos .. $];
				break;
		}
	}
}
