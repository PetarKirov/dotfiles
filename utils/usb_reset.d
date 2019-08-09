import std.conv, std.exception, std.stdio, core.sys.posix.sys.ioctl;

void main(string[] args)
{
    enum USBDEVFS_RESET = 21780;
    enforce(args.length == 2, "Usage: usbreset device-filename");
    auto f = File(args[1], "w");
    writeln("Resetting USB device: ", args[1]);
    (f.fileno.ioctl(USBDEVFS_RESET, 0) != -1).errnoEnforce();
    writeln("Reset successful.");
}
