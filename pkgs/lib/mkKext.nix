{ pname, version, src, stdenv
, installPhase ? ''
    mkdir -p $out/Kexts
    cp -r ./*.kext $out/Kexts
  ''
}:

let
  finalInstallPhase = ''
    runHook preInstall
  '' + installPhase + ''
    runHook postInstall
  '';
in
stdenv.mkDerivation rec
{
  inherit pname version src;

  installPhase = finalInstallPhase;
}
