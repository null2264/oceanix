{ lib, pkgs }:
{
  cpufriend = (import ../../stdPkger.nix {
    inherit lib pkgs;
    pname = "cpufriend";
    path = ./.;
  });
}
