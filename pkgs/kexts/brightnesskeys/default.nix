{ lib, pkgs }:

{
  brightnesskeys = (import ../../stdPkger.nix {
    inherit lib pkgs;
    pname = "brightnesskeys";
    path = ./.;
  });
}
