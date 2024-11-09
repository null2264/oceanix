{ lib, pkgs }:

{
  whatevergreen = (import ../../stdPkger.nix {
    inherit lib pkgs;
    pname = "whatevergreen";
    path = ./.;
  });
}
