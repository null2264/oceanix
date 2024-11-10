{ lib, stdenv, fetchzip, release ? true, ver ? "latest" }:
let
  mkKext = import ../../lib/mkKext.nix;
  versionList = (import ./version.nix { inherit lib; });
in mkKext rec {
  pname = "applealc-${if release then "release" else "debug"}";
  version = versionList."${ver}".canonicalVersion;

  src = fetchzip {
    url =
      "https://github.com/acidanthera/AppleALC/releases/download/${version}/AppleALC-${version}-${
        if release then "RELEASE" else "DEBUG"
      }.zip";
    hash = versionList."${ver}"."${if release then "release" else "debug"}";
    stripRoot = false;
  };

  inherit stdenv;
}
