{ lib, stdenv, fetchzip, ver ? "latest" }:
let
  mkKext = import ../../lib/mkKext.nix;
  versionList = (import ./version.nix { inherit lib; });
in mkKext rec {
  pname = "itlwm";
  version = versionList."${ver}".canonicalVersion;

  src = fetchzip {
    inherit (versionList."${ver}") url sha256;
    stripRoot = false;
  };

  inherit stdenv;
}
