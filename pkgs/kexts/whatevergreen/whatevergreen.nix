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
  pname = "whatevergreen-${if release then "release" else "debug"}";

  src = fetchzip {
    inherit hash;
    url =
      "https://github.com/acidanthera/WhateverGreen/releases/download/${version}/WhateverGreen-${version}-${
        if release then "RELEASE" else "DEBUG"
      }.zip";
    stripRoot = false;
  };

  inherit stdenv;
}
