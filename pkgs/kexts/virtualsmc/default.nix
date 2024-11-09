{ lib, pkgs }:

{
  virtualsmc = (import ../../stdPkger.nix {
    inherit lib pkgs;
    pname = "virtualsmc";
    path = ./.;
  });
}
