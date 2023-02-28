#!/usr/bin/env dub
/+ dub.sdl:
	name "hello"
    dependency "optional" version="~>1.3.0"
    buildRequirements "silenceWarnings"
+/

import std.algorithm;
import std.range;
import std.conv : to;
import std.format : fmt = format;
import std.exception : enforce;
import core.stdc.stdlib : exit;
import std.file : readLink;

debug import std.stdio : writeln, writefln;

import optional : Optional, no, some;

struct UiConfig
{
    bool interactive;
    bool dryRun;
    bool keepPartitions;
}

struct DevicePartitionConfig
{
    ulong espSize = 4.GiB;
    ulong swapSize = 16.GiB;
    ulong alignment = 1.MiB;
    string primaryDevicePath;
    string zfsPoolName = "zfs_root";
    string[] additionalDevicePaths;
    ZfsDataset[] zfsDatasets;
}

void main(string[] args)
{
    auto zfsDatasets = [
        // Root
        ZfsDataset("nixos", ["mountpoint": "/", "canmount": "on"]),

        // Reserved
        ZfsDataset("reserved", ["mountpoint": "none", "refreservation": "5G"]),

        // Nix Store
        ZfsDataset("nixos/nix", ["canmount": "on", "refreservation": "50G"]),

        // Docker
        ZfsDataset("nixos/var", ["canmount": "on"]),
        ZfsDataset("nixos/var/lib", ["canmount": "on"]),
        ZfsDataset("nixos/var/lib/docker", ["canmount": "on", "quota": "200G"]),

        // Home
        ZfsDataset("userdata", ["canmount": "off", "mountpoint": "/"]),
        ZfsDataset("userdata/home", ["canmount": "on", "refreservation": "75G", "reservation": "150G"]),
    ];

    DevicePartitionConfig partitionConfig = {
        zfsDatasets: zfsDatasets,
    };

    const config = parseConfigFromEnvVariables();
    Context ctx = new Context(config);


    // get_block_device_ids(ctx).writefln!"%-(%-s\n%)";


    // string primaryDevice;

    // ctx.create_zfs_datasets(partitionConfig.zfsPoolName, partitionConfig.zfsDatasets);

    //   prompt "Please enter block device id path you want to operate on:"
    //   DISK_ID="$REPLY"
    //   while [[ "${DISK_ID}" != /dev/disk/by-id/* ]]; do
    //     echo "Expected path to start with '${bold}/dev/disk/by-id/${offbold}'"
    //     echo "Got: '$DISK_ID'"
    //     echo "Try again:"
    //     prompt "Please enter the block device you want to operate on:"
    //   done
    //   DISK_ID_ONLY="${DISK_ID##/dev/disk/by-id/}"

    //   if [[ "${DISK_ID}" == *-part* ]]; then
    //     echo "Expected \$DISK_ID to identify a whole disk (storage device), not a partition"
    //     echo "(\$DISK_ID='$DISK_ID')"
    //     exit 1
    //   fi

    //   test -b "$DISK_ID" || log_error "'$DISK_ID' does not exist or is not a block device"

    //   DEV="$(readlink -f "$DISK_ID")"
    //   DEV_NAME="${DEV##/dev/}"
    //   DEV_SECTORS="$(cat "/sys/block/${DEV_NAME}"/size)"
    //   DEV_SECTOR_SIZE="$(cat "/sys/block/${DEV_NAME}"/queue/hw_sector_size)"
    //   DEV_SIZE="$(( DEV_SECTORS * DEV_SECTOR_SIZE ))"

    //   FS_TYPE_ESP="ef00"
    //   FS_TYPE_SWAP="8200"
    //   FS_TYPE_ROOT="bf00"

    //   KiB=1024
    //   MiB=$((1024 * KiB))
    //   GiB=$((1024 * MiB))

    //   ALIGN=${MiB}

    //   DEV_SIZE_A=$(( DEV_SIZE / ALIGN ))

    //   draw_box "Info" << EOF
    // Device: '${bold}${DEV}${offbold}'
    // ID: '${bold}${DISK_ID_ONLY}${offbold}'
    // Size: $(format_size "$DEV_SIZE") ($DEV_SIZE bytes)
    // Sector size: $(format_size "$DEV_SECTOR_SIZE") ($DEV_SECTOR_SIZE bytes)
    // Alignment: $(format_size "$ALIGN") ($ALIGN bytes)
    // EOF
    //   ESP_SIZE=$(( ESP_SIZE_GiB * GiB ))
    //   ESP_START="$(( 1 * ALIGN ))"
    //   ESP_END="$(( ESP_START + ESP_SIZE - DEV_SECTOR_SIZE ))"
    //   ESP_START_S="$(( ESP_START / DEV_SECTOR_SIZE ))"
    //   ESP_END_S="$(( ESP_END / DEV_SECTOR_SIZE ))"

    //   SWAP_SIZE=$(( SWAP_SIZE_GiB * GiB ))
    //   SWAP_SIZE_A=$(( SWAP_SIZE / ALIGN ))

    //   SWAP_START="$(( (DEV_SIZE_A - SWAP_SIZE_A) * ALIGN ))"
    //   SWAP_END="$(( SWAP_START + SWAP_SIZE - DEV_SECTOR_SIZE ))"
    //   SWAP_START_S="$(( SWAP_START / DEV_SECTOR_SIZE ))"
    //   SWAP_END_S="$(( SWAP_END / DEV_SECTOR_SIZE ))"

    //   ROOT_START="$(( ESP_END + DEV_SECTOR_SIZE ))"
    //   ROOT_END="$(( SWAP_START - DEV_SECTOR_SIZE ))"
    //   ROOT_START_S="$(( ROOT_START / DEV_SECTOR_SIZE ))"
    //   ROOT_END_S="$(( ROOT_END / DEV_SECTOR_SIZE ))"

    //   if [[ "$KEEP_PARTITIONS" == "true" ]]; then
    //     print_one_device "$DISK_ID" | draw_box "The following partitions will be kept:"
    //   else
    //     {
    //       print_partition_layout "ESP" "$ESP_START" "$ESP_END"
    //       print_partition_layout "ROOT" "$ROOT_START" "$ROOT_END"
    //       print_partition_layout "SWAP" "$SWAP_START" "$SWAP_END"
    //     } | draw_box "The following partitions will be created:" false
    //   fi


    //   ESP_PART_NUM=1
    //   ROOT_PART_NUM=2
    //   SWAP_PART_NUM=3

    //   [[ "$KEEP_PARTITIONS" != "true" ]] && {
    //     confirm
    //     force_create_gpt
    //     add_gpt_partition $ESP_PART_NUM "$ESP_START_S" "$ESP_END_S" "$FS_TYPE_ESP" "esp"
    //     add_gpt_partition $ROOT_PART_NUM "$ROOT_START_S" "$ROOT_END_S" "$FS_TYPE_ROOT" "zfs_root"
    //     add_gpt_partition $SWAP_PART_NUM "$SWAP_START_S" "$SWAP_END_S" "$FS_TYPE_SWAP" "swap"
    //     print_gpt_partition_info
    //   } | draw_box "Partitioning '$DISK_ID'"

    //   local esp_partition
    //   esp_partition="$(partition_id "$ESP_PART_NUM")"

    //   local zfs_pool_name=zfs_root

    //   if check_zfs_pool "$zfs_pool_name"; then
    //     print_zfs_info | draw_box "A pool named '${zfs_pool_name}' already exists:"
    //     confirm "Are you sure you want to destroy it and create a new one? (yes/no)"
    //     run_cmd sudo umount -R /mnt || true
    //     run_cmd sudo zpool destroy zfs_root
    //   fi

    //   {
    //     create_single_disk_zfs_root_fs "$zfs_pool_name" $ROOT_PART_NUM
    //     create_zfs_datasets "$zfs_pool_name" "$esp_partition"
    //     print_zfs_info
    //   } | draw_box "Creating zpool and zfs datasets"

    //   {
    //     run_cmd sudo mkdir -p /mnt/boot
    //     run_cmd sudo mount "$esp_partition" /mnt/boot
    //   } | draw_box "Mounting file systems"

    // Translation of the above script to D

    printDevices(ctx.disableDryRun());
    auto diskIdPath = "/dev/disk/by-id/";

    auto diskId = prompt("Please enter block device id path you want to operate on:");
    while (!diskId.startsWith(diskIdPath))
    {
        writefln("Expected path to start with '%s/dev/disk/by-id/%s'",
            cast(string)TermAnsiEscSeq.bold,
            cast(string)TermAnsiEscSeq.noBold);
        writefln("Got: '%s'", diskId);
        writefln("Please try again.");
        diskId = prompt("Please enter block device id path you want to operate on:");
    }

    diskIdPath
        .isBlockDevice()
        .enforce("'%s' does not exist or is not a block device".fmt(diskIdPath));

    auto diskIdOnly = diskId.split(diskIdPath)[1];

    if (diskIdOnly.canFind("-part"))
    {
        writeln("Expected disk id to identify a whole disk (storage device), not a partition");
        writefln("DISK_ID: '%s'", diskId);
        exit(1);
    }


}

bool isBlockDevice(string path)
{
    import std.file : exists, DirEntry;
    import core.sys.posix.sys.stat : S_IFBLK;

    if (!exists(path))
        return false;

    auto de = DirEntry(path);
    return (de.statBuf.st_mode & S_IFBLK) != 0;
}

UiConfig parseConfigFromEnvVariables()
{
    import std.process : environment;
    UiConfig config = {
        interactive: environment.get("INTERACTIVE", "true").parseBoolean(),
        dryRun: environment.get("DRY_RUN", "true").parseBoolean(),
        keepPartitions: environment.get("KEEP_PARTITIONS", "true").parseBoolean(),
    };
    return config;
}

bool parseBoolean(string value)
{
    import std.algorithm : among;
    import std.string : toLower;
    value = value.toLower;

    if (value.among("true", "yes", "y", "1"))
        return true;
    else if (value.among("false", "no", "n", "0"))
        return false;
    else
        throw new Exception("Invalid boolean value: " ~ value);
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
  `blkdiscard -f '$devicePath'`.runSudoCommand!(devicePath)(ctx);
  `sgdisk --zap-all '$devicePath'`.runSudoCommand!(devicePath)(ctx);
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
    `sgdisk
        -n${partnum}:${start}:${end}
        -t${partnum}:${type}
        -c${partnum}:${name} "$DEV"
    `
        .runSudoCommand!(partnum, start, end, type, name)(ctx);

    string partitionPath = partition_id(devicePath, partnum);
    checkPartition(ctx, partitionPath);

    final switch (name)
    {
        case "swap":
            `mkswap -L swap '$partitionPath'`
                .runSudoCommand!(partitionPath)(ctx);
            break;
        case "esp":
            `mkfs.fat -F 32 -n EFI '$partitionPath'`
                .runSudoCommand!(partitionPath)(ctx);
            break;
    }
}

void printDevices(Context ctx) {
    foreach (devicePath; get_block_device_ids(ctx))
        ctx.drawBox(devicePath, ctx2 => print_one_device(ctx2, devicePath));
}

void print_one_device(Context ctx, string devicePath) {
    `lsblk -o tran,name,size,fstype,mountpoints,label,partlabel,serial '$devicePath'`
        .runCommand!(devicePath)(ctx);
}

string[] getAllDiskByIds() {
    import std.file : dirEntries, SpanMode;
    return "/dev/disk/by-id/"
        .dirEntries(SpanMode.shallow)
        .map!(e => e.name)
        .array;
}

string[] get_block_device_ids(Context ctx)
{
    import std.range : tee;
    import std.algorithm.searching : canFind;
    import std.file : exists, readLink;
    import std.string : lineSplitter;
    import std.typecons : tuple;

    return "lsblk -dn -o kname".runCommandGetOutput(ctx)
        .lineSplitter
        .map!(kname => getAllDiskByIds()
            .filter!(diskId => diskId.readLink.endsWith(kname))
            .map!(diskId => tuple(kname, diskId))
        )
        .joiner
        .array
        .filter!(function (pair) {
            auto kname = pair[0];
            auto id_name = pair[1];
            auto wwid = kname.getWwidFromKname;
            return !wwid.empty && id_name.canFind(wwid.front);
        })
        .map!(pair => pair[1])
        .array;
}

Optional!string getWwidFromKname(string kname)
{
    auto possiblePaths = [
        "/sys/block/$kname/wwid",
        "/sys/block/$kname/device/wwid"
    ];

    auto res = possiblePaths
        .map!(p => p
            .replaceVars!kname
            .tryReadFile
            .map!(content => content.split(".")[1])
        )
        .joiner;

    return res.empty ? no!string : some(res.front);
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
    `'$poolName'` ~
    `'$partitionPath'`)
    .runSudoCommand!(poolName, partitionPath)(ctx);
}

bool check_zfs_pool(string poolName) {
    return `zpool status`.runCommandGetSuccess(poolName);
}

struct ZfsDataset
{
    string name;
    string[string] options;
}

void create_zfs_datasets(Context ctx, string poolName, const ZfsDataset[] datasets)
{
    foreach (dataset; datasets)
        `zfs create "%s/%s"`
            .opts(dataset.options)
            .runSudoCommand(ctx, poolName, dataset.name);
}

void printZfsInfo(Context ctx) {
    `zpool status`.runSudoCommand(ctx);
    `zfs list -r`.runSudoCommand(ctx);
}

void printGptPartitionInfo(Context ctx, string devicePath, string diskId) {
    `sgdisk -p "%s"`.runSudoCommand(ctx, devicePath);
    `parted "%s" -- unit MiB print free`.runSudoCommand(ctx, devicePath);
    ctx.drawBox("Disk IDs", ctx =>

        `ls -la '/dev/disk/by-id/' | grep "$diskId"`.runCommand!(diskId)(ctx)
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
  return $r
}
+/

string format_size(Context ctx, ulong size) {
  return TermAnsiEscSeq.bold ~
    `numfmt --to=iec-i --suffix=B --round=nearest -- %s`
        .runCommandGetOutput(ctx, size) ~
    TermAnsiEscSeq.normal;
}

string horizontalLine(size_t length)
{
    return repeatStr(length, "─");
}

string repeatStr(size_t length, string str)
{
    import std.range : repeat;
    return str.repeat(length).joiner.to!string;
}

string remove_ansi_escapes(string input)
{
    import std.regex;
    auto re = regex("\x1b\\[([0-9]{1,2}(;[0-9]{1,2})*)?[m|K]", "g");
    return input.replaceAll(re, "");
}

Optional!string tryReadFile(string path)
{
    import std.file : readText;
    import std.string : strip;
    try
        return path.readText.strip.some;
    catch (Exception ex)
        return no!string;
}

string opts(string cmdLine, const string[string] opts)
{
    return "%s %(-o %(%s=%s%)%| %)".fmt(cmdLine, opts.byPair);
}

string runSudoCommand(Args...)(string cmd, Context ctx, Args args)
{
    const command = fmt("sudo " ~ cmd, args);
    return ctx.runCommandGetOutput(command, true);
}

void runSudoCommand(vars...)(string format, Context ctx)
if (vars.length > 0)
{
    ctx.runCommandGetOutput(format.replaceVars!vars, true);
}

void runCommand(vars...)(string format, Context ctx)
{
    ctx.runCommandGetOutput(format.replaceVars!vars, true);
}

bool runCommandGetSuccess(Args...)(string cmd, Args args)
{
    import std.process : executeShell;
    const command = fmt(cmd, args);
    const result = executeShell(cmd);
    return result.status == 0;
}

string runCommandGetOutput(Args...)(string cmd, Context ctx, Args args)
{
    const command = fmt(cmd, args);
    return ctx.runCommandGetOutput(command, false);
}

class Context
{
    UiConfig config;

    this(UiConfig config)
    {
        this.config = config;
    }

    Context disableDryRun()
    {
        auto newConfig = this.config;
        newConfig.dryRun = false;
        return new Context(newConfig);
    }

    string output;

    string runCommandGetOutput(string cmd, bool trace)
    {
        import std.stdio : writefln;
        import std.process : executeShell;
        import std.string : strip, replace;

        cmd = cmd.strip.replace("\n", " ");

        if (trace)
            writefln("> %s", TermAnsiEscSeq.bold ~ cmd ~ TermAnsiEscSeq.normal);

        if (this.config.dryRun)
            this.output = "";
        else
        {
            const result = executeShell(cmd);
            enforce(result.status == 0);
            this.output = result.output;
        }
        return this.output;
    }
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
        vars[var.stringof] = var.to!string;

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

void drawBox(Context ctx, string label, void delegate(Context ctx) callback, bool drawLeftBoxSide = true, bool resetEscSeq = false)
{
    import std.stdio : writefln;
    import std.string : format, lineSplitter;

    auto title = TermAnsiEscSeq.bold ~ label ~ TermAnsiEscSeq.noBold;
    auto titleLen = label.length;

    auto childContext = new Context(ctx.config);
    callback(childContext);
    auto output = childContext.output;

    auto outputWidth = output.lineSplitter.map!"a.length".maxElement;

    string prefix;
    if (drawLeftBoxSide)
        prefix = "│ ";
    else
        prefix = "";

    auto prefixLen = prefix.length;

    size_t innerWidth = 0;

    if (titleLen > 0)
    {
        auto topBorderLen = outputWidth + prefixLen - titleLen - 7;
        string topBorder;
        if (topBorderLen <= 0)
        {
            topBorderLen = 0;
            topBorder = "";
        }
        else
        {
            topBorder = horizontalLine(topBorderLen);
        }
        innerWidth = 3 + titleLen + 2 + topBorderLen;
        writefln("╭──╼ %s ╾%s─╮", title, topBorder);
    }
    else
    {
        auto topBorder = horizontalLine(outputWidth + prefixLen - 3);
        innerWidth = 1 + topBorder.length;
        writefln("╭──%s─╮", topBorder);
    }

    auto bottomBorder = horizontalLine(innerWidth);

    outputWidth = innerWidth - (prefixLen - 2);

    foreach (line; output.lineSplitter)
    {
        auto lineLength = line.remove_ansi_escapes.length;

        auto rightPadLen = outputWidth - lineLength;
        auto rightPad = repeatStr(rightPadLen, " ");

        writefln("%s%s%s │", prefix, line, rightPad);
    }

    writefln("╰─%s─╯%s", bottomBorder, resetEscSeq ? TermAnsiEscSeq.noColor : "");
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
