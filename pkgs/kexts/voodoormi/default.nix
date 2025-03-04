{ lib, pkgs }:
{
  voodoormi = (import ../../stdPkger.nix {
    inherit lib pkgs;
    pname = "voodoormi";
    path = ./.;
  });
}
