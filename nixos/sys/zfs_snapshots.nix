{
  lib,
  config,
  ...
}: {
  services.zfs =
    lib.mkIf config.boot.zfs.enabled
    {
      autoSnapshot = {
        enable = true;
      };
    };
}
