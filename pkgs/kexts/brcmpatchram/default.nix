{ lib, pkgs }:

{
  brcmpatchram = (import ../../stdPkger.nix {
    inherit lib pkgs;
    pname = "brcmpatchram";
    path = ./.;
  });
}
