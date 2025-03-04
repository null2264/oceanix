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
  pname = "cputscsync";

  src = fetchzip {
    inherit hash;
    url = "https://github.com/acidanthera/CpuTscSync/releases/download/${version}/CpuTscSync-${version}-${if release then "RELEASE" else "DEBUG"}.zip";
    stripRoot = false;
  };

  inherit stdenv;
}
