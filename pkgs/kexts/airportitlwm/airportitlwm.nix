{ lib, stdenv, fetchzip, ver ? "latest", osVer }:
let
  mkKext = import ../../lib/mkKext.nix;
  versionList = (import ./version.nix { inherit lib; });
in mkKext rec {
  pname = "airportitlwm";
  version = versionList."${ver}".canonicalVersion;

  src = fetchzip {
    url = versionList."${ver}".mkUrl osVer;
    hash = versionList."${ver}"."${osVer}";
    stripRoot = false;
  };

  inherit stdenv;
}
