{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  cmake,
  fontconfig,
  udev,
  asusctlVersionInfo,
}:
rustPlatform.buildRustPackage rec {
  pname = "asusctl";
  version = asusctlVersionInfo.version;

  src = fetchFromGitLab {
    owner = "asus-linux";
    repo = pname;
    rev = version;
    sha256 = asusctlVersionInfo.sha256;
  };

  nativeBuildInputs = [pkg-config cmake];
  buildInputs = [udev fontconfig];

  cargoSha256 = asusctlVersionInfo.cargoSha256;

  meta = with lib; {
    description = "CLI tools for interacting with ASUS ROG laptops";
    homepage = "https://asus-linux.org/";
    license = licenses.mpl20;
    maintainers = [];
  };
}
