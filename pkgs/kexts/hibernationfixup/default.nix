{ lib, pkgs }:
{
  hibernationfixup = (import ../../stdPkger.nix {
    inherit lib pkgs;
    pname = "hibernationfixup";
    path = ./.;
  });
}
