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
  pname = "rtcmemoryfixup-${if release then "release" else "debug"}";

  src = fetchzip {
    inherit hash;
    url =
      "https://github.com/acidanthera/RTCMemoryFixup/releases/download/${version}/RTCMemoryFixup-${version}-${
        if release then "RELEASE" else "DEBUG"
      }.zip";
    stripRoot = false;
  };

  inherit stdenv;
}
