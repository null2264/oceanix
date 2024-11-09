{ lib, pkgs }:

{
  nvmefix = (import ../../stdPkger.nix {
    inherit lib pkgs;
    pname = "nvmefix";
    path = ./.;
  });
}
