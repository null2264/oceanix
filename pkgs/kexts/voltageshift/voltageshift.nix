{ lib, stdenv, fetchzip, ver ? "latest" }:
let
  mkKext = import ../../lib/mkKext.nix;
  versionList = (import ./version.nix { inherit lib; });
in mkKext rec {
  pname = "voltageshift";
  version = versionList."${ver}".canonicalVersion;

  src = fetchzip {
    url = "https://github.com/sicreative/VoltageShift/raw/refs/heads/master/voltageshift_${version}.zip";
    sha256 = versionList."${ver}".hash;
    stripRoot = false;
  };

  inherit stdenv;
}
