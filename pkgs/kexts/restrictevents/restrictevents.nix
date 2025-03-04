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
  pname = "restrictevents";

  src = fetchzip {
    inherit hash;
    url = "https://github.com/acidanthera/RestrictEvents/releases/download/${version}/RestrictEvents-${version}-${if release then "RELEASE" else "DEBUG"}.zip";
    stripRoot = false;
  };

  inherit stdenv;
}
