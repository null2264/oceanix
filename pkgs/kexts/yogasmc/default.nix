{ lib, pkgs }:
{
  yogasmc = (import ../../stdPkger.nix {
    inherit lib pkgs;
    pname = "yogasmc";
    path = ./.;
  });
}
