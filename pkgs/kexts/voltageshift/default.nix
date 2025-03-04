{ lib, pkgs }:
{
  voltageshift = (import ../../pkger.nix {
    inherit lib pkgs;
    path = ./.;
    fn = ver: {
      "${ver}" = pkgs.callPackage ./voltageshift.nix { inherit ver; };
    };
  });
}
