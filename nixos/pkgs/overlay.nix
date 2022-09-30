_finalNixpkgs: prevNixpkgs: let
  rustPlatform = prevNixpkgs.makeRustPlatform {
    cargo = prevNixpkgs.cargo;
    rustc = prevNixpkgs.rust-bin.stable.latest.default;
  };
  asusctl = prevNixpkgs.callPackage ./asusctl {
    inherit rustPlatform;
    asusctlVersionInfo = (import ./asusctl/version.nix).default;
  };
in {
  my-pkgs = rec {
    inherit asusctl;
  };
}
