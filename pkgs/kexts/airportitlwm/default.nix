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
      builtins.listToAttrs (map
        (x: lib.attrsets.nameValuePair "${ver}-${lib.strings.toLower x}" (pkgs.callPackage ./airportitlwm.nix {
          inherit ver;
          osVer = x;
        }))
        verInfo."${ver}".supportedOS);
  });
}
