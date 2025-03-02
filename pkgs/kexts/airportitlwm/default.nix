{ lib, pkgs }:

{
  airportitlwm = (import ../../pkger.nix {
    inherit lib pkgs;
    path = ./.;
    fn = ver:
      let
        verInfo = import ./version.nix {
          inherit lib;
        };
      in
      builtins.listToAttrs (lib.attrsets.mapAttrs'
        (osVer: hash: lib.attrsets.nameValuePair "${ver}-${lib.strings.toLower osVer}" (pkgs.callPackage ./airportitlwm.nix {
          inherit osVer hash;
          url = verInfo."${ver}".mkUrl osVer;
          canonicalVersion = verInfo."${ver}".canonicalVersion;
          versionName = ver;
        }))
        verInfo."${ver}".os);
  });
}
