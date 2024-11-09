{ lib, pkgs }:
{
  voodooi2c = (import ../../pkger.nix {
    inherit lib pkgs;
    path = ./.;
    fn = ver: {
      "${ver}" = pkgs.callPackage ./voodooi2c.nix { inherit ver; };
    };
  });
}
