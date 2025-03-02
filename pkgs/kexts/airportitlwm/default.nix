{ lib, pkgs }:

let
  mkUrl = version: osVer: "https://github.com/OpenIntelWireless/itlwm/releases/download/${version}/AirportItlwm_${version}_stable_${osVer}.kext.zip";
in {
  airportitlwm = (import ../../pkger.nix {
    inherit lib pkgs;
    path = ./.;
    fn = ver:
      let
        verInfo = import ./version.nix {
          inherit lib;
        };
        canonicalVersion = verInfo."${ver}".canonicalVersion;
      in
      builtins.listToAttrs (lib.attrsets.mapAttrs'
        (osVer: hash: lib.attrsets.nameValuePair "${ver}-${lib.strings.toLower osVer}" (pkgs.callPackage ./airportitlwm.nix {
          inherit osVer hash canonicalVersion;
          url = mkUrl canonicalVersion osVer;
          versionName = ver;
        }))
        verInfo."${ver}".os);
  });
}
