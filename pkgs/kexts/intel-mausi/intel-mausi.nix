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
  pname = "intel-mausi";

  src = fetchzip {
    inherit hash;
    url =
      "https://github.com/acidanthera/IntelMausi/releases/download/${version}/IntelMausi-${version}-${
        if release then "RELEASE" else "DEBUG"
      }.zip";
    stripRoot = false;
  };

  inherit stdenv;
}
