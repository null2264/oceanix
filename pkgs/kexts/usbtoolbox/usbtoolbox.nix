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
  pname = "usbtoolbox-${if release then "release" else "debug"}";

  src = fetchzip {
    inherit hash;
    url =
      "https://github.com/USBToolBox/kext/releases/download/${version}/USBToolBox-${version}-${
        if release then "RELEASE" else "DEBUG"
      }.zip";
    stripRoot = false;
  };

  inherit stdenv;
}
