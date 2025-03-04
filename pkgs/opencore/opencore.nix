{ lib, stdenv, fetchzip, rsync,
  release ? true,
  version,
  hash,
  ...
}:
stdenv.mkDerivation rec {
  inherit version;
  pname = "opencore-${if release then "release" else "debug"}";

  src = fetchzip {
    inherit hash;
    url =
      "https://github.com/acidanthera/OpenCorePkg/releases/download/${version}/OpenCore-${version}-${
        if release then "RELEASE" else "DEBUG"
      }.zip";
    stripRoot = false;
  };

  nativeBuildInputs = [ rsync ];

  installPhase = ''
    mkdir $out
    cp -r . $out
  '';
}
