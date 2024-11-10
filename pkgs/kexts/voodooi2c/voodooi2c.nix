{ lib, stdenv, fetchzip, ver ? "latest" }:
let
  mkKext = import ../../lib/mkKext.nix;
  versionList = (import ./version.nix { inherit lib; });
in mkKext rec {
  pname = "voodooi2c";
  version = versionList."${ver}".canonicalVersion;

  src = fetchzip {
    url =
      "https://github.com/VoodooI2C/VoodooI2C/releases/download/${version}/VoodooI2C-${version}.zip";
    sha256 = versionList."${ver}".hash;
    stripRoot = false;
  };

  inherit stdenv;
}
