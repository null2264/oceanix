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
  pname = "brcmpatchram";

  src = fetchzip {
    inherit hash;
    url =
      "https://github.com/acidanthera/BrcmPatchRAM/releases/download/${version}/BrcmPatchRAM-${version}-${
        if release then "RELEASE" else "DEBUG"
      }.zip";
    stripRoot = false;
  };

  inherit stdenv;
}
