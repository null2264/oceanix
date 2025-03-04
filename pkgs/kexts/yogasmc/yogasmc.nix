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
  pname = "debugenhancer";

  src = fetchzip {
    inherit hash;
    url = "https://github.com/zhen-zen/YogaSMC/releases/download/${version}/DebugEnhancer-${if release then "RELEASE" else "DEBUG"}.zip";
    stripRoot = false;
  };

  inherit stdenv;
}
