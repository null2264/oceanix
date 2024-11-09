{ lib, stdenv, fetchzip, ver ? "latest", osVer }:
let versionList = (import ./version.nix { inherit lib; });
in stdenv.mkDerivation rec {
  pname = "airportitlwm";
  version = versionList."${ver}".canonicalVersion;

  src = fetchzip {
    url = versionList."${ver}".mkUrl osVer;
    hash = versionList."${ver}"."${osVer}";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/Kexts
    cp -r ./*.kext $out/Kexts
  '';
}
