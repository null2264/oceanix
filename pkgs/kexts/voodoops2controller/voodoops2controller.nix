{ lib, stdenv, fetchzip, release ? true, ver ? "latest" }:
let
  mkKext = import ../../lib/mkKext.nix;
  versionList = (import ./version.nix { inherit lib; });
in mkKext rec {
  pname = "voodoops2controller-${if release then "release" else "debug"}";
  version = versionList."${ver}".canonicalVersion;

  src = fetchzip {
    url =
      "https://github.com/acidanthera/VoodooPS2/releases/download/${if (builtins.compareVersions version "2.3.0") != 0 then ("v" + version) else version}/VoodooPS2Controller-${version}-${
        if release then "RELEASE" else "DEBUG"
      }.zip";
    sha256 = versionList."${ver}"."${if release then "release" else "debug"}";
    stripRoot = false;
  };

  inherit stdenv;
}
