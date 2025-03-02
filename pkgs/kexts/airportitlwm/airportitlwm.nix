{ lib, stdenv, fetchzip,
  versionName ? "latest",
  canonicalVersion,
  osVer,
  url,
  hash,
  ...
}:

let
  mkKext = import ../../lib/mkKext.nix;
in mkKext rec {
  pname = "airportitlwm";
  version = canonicalVersion;

  src = fetchzip {
    inherit hash url;
    stripRoot = false;
  };

  inherit stdenv;
}
