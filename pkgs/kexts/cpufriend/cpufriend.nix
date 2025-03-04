{ lib, stdenv, fetchzip,
  release ? true,
  version,
  hash,
  ...
}:
let
  mkKext = import ../../lib/mkKext.nix;
in mkKext rec {
  inherit version;
  pname = "cpufriend";

  src = fetchzip {
    inherit hash;
    url = "https://github.com/acidanthera/CPUFriend/releases/download/${version}/CPUFriend-${version}-${if release then "RELEASE" else "DEBUG"}.zip";
    stripRoot = false;
  };

  inherit stdenv;
}
