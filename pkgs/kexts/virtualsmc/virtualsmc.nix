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
  pname = "virtualsmc-${if release then "release" else "debug"}";

  src = fetchzip {
    inherit hash;
    url =
      "https://github.com/acidanthera/VirtualSMC/releases/download/${version}/VirtualSMC-${version}-${
        if release then "RELEASE" else "DEBUG"
      }.zip";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/Kexts
    cp -r ./Kexts/*.kext $out/Kexts
  '';

  inherit stdenv;
}
