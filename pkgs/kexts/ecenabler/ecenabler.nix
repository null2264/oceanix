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
  pname = "ecenabler";

  src = fetchzip {
    inherit hash;
    url =
      "https://github.com/1Revenger1/ECEnabler/releases/download/${version}/ECEnabler-${version}-${
        if release then "RELEASE" else "DEBUG"
      }.zip";
    stripRoot = false;
  };

  inherit stdenv;
}
