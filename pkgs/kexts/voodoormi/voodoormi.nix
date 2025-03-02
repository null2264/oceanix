{ lib, stdenv, fetchzip,
  versionName ? "latest",
  type ? "Release",
  version,
  hash,
  ...
}:
let
  mkKext = import ../../lib/mkKext.nix;
  versionList = (import ./version.nix { inherit lib; });
in mkKext rec {
  inherit version;
  pname = "voodoormi";

  src = fetchzip {
    inherit hash;
    url = "https://github.com/VoodooSMBus/VoodooRMI/releases/download/${version}/VoodooRMI-${version}-${type}.zip";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/Kexts
    cp -r ./VoodooRMI-*/*.kext $out/Kexts
  '';

  inherit stdenv;
}
