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
  pname = "voodoormi";

  src = fetchzip {
    inherit hash;
    url = "https://github.com/VoodooSMBus/VoodooRMI/releases/download/${version}/VoodooRMI-${version}-${if release then "RELEASE" else "DEBUG"}.zip";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/Kexts
    cp -r ./VoodooRMI-*/*.kext $out/Kexts
  '';

  inherit stdenv;
}
