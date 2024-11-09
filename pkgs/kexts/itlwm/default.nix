{ lib, pkgs }:

{
  itlwm = (import ../../pkger.nix rec {
    inherit lib pkgs;
    path = ./.;
    fn = let pname = "itlwm"; in ver: {
      "${ver}" = pkgs.callPackage (path + "/${pname}.nix") {
        inherit ver;
      };
    };
  });
}
