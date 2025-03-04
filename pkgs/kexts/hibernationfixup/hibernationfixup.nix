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
  pname = "hibernationfixup";

  src = fetchzip {
    inherit hash;
    url = "https://github.com/acidanthera/HibernationFixup/releases/download/${version}/HibernationFixup-${version}-${if release then "RELEASE" else "DEBUG"}.zip";
    stripRoot = false;
  };

  inherit stdenv;
}
