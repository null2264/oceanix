{ lib, pkgs }:

{
  ecenabler = (import ../../stdPkger.nix {
    inherit lib pkgs;
    pname = "ecenabler";
    path = ./.;
  });
}
