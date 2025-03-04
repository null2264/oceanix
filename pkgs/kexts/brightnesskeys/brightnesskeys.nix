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
  pname = "brightnesskeys";

  src = fetchzip {
    inherit hash;
    url =
      "https://github.com/acidanthera/BrightnessKeys/releases/download/${version}/BrightnessKeys-${version}-${
        if release then "RELEASE" else "DEBUG"
      }.zip";
    stripRoot = false;
  };

  inherit stdenv;
}
