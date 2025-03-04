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
  pname = "applealc";

  src = fetchzip {
    inherit hash;
    url =
      "https://github.com/acidanthera/AppleALC/releases/download/${version}/AppleALC-${version}-${if release then "RELEASE" else "DEBUG"}.zip";
    stripRoot = false;
  };

  inherit stdenv;
}
