with builtins; let
  splitPath = path: filter (x: (typeOf x) == "string") (split "/" path);
  pathTail = path: concatStringsSep "/" (tail (splitPath path));
  makeZfs = zfsRoot: zfsDataset: {
    name = "/" + pathTail zfsDataset;
    value = {
      device = "${zfsRoot}/${zfsDataset}";
      fsType = "zfs";
      options = ["zfsutil"];
    };
  };
in {
  zfsFileSystems = {
    datasets,
    zfsRoot ? "zfs_root",
  }:
    listToAttrs (map (makeZfs zfsRoot) datasets);
}
