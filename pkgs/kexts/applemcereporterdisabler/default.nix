{ lib, pkgs }:

let
  mkKext = import ../../lib/mkKext.nix;
in {
  applemcereporterdisabler = (mkKext rec {
    pname = "applemcereporterdisabler";
    version = "1.0.0";

    src = fetchzip {
      url = "https://github.com/acidanthera/bugtracker/files/3703498/AppleMCEReporterDisabler.kext.zip";
      hash = "sha256-I1PcfchLqRXJAu5TEjK1wrgPL91pLCgEunxwlvhbueM=";
      stripRoot = false;
    };

    inherit stdenv;
  });
}
