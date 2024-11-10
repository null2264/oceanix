{ lib, stdenv, fetchzip, ver ? "latest" }:
let
  mkKext = import ../../lib/mkKext.nix;
  versionList = (import ./version.nix { inherit lib; });
in mkKext rec {
  pname = "intel-bluetooth-firmware";
  version = versionList."${ver}".canonicalVersion;

  src = fetchzip {
    url =
      "https://github.com/OpenIntelWireless/IntelBluetoothFirmware/releases/download/${version}/IntelBluetooth-${version}.zip";
    sha256 = versionList."${ver}".hash;
    stripRoot = false;
  };

  inherit stdenv;
}
