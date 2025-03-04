{ lib, stdenv, fetchzip,
  versionName ? "latest",
  type ? "Release",
  version,
  hash,
  ...
}:
let
  mkKext = import ../../lib/mkKext.nix;
  versionList = (import ./version.nix { inherit lib; });
in mkKext rec {
  inherit version;
  pname = "cpufriend";

  src = fetchzip {
    inherit hash;
    url = "https://github.com/acidanthera/CPUFriend/releases/download/${version}/CPUFriend-${version}-${lib.strings.toUpper type}.zip";
    stripRoot = false;
  };

  inherit stdenv;
}
