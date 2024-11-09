{ lib, pkgs }:

{
  usbtoolbox = (import ../../stdPkger.nix {
    inherit lib pkgs;
    pname = "usbtoolbox";
    path = ./.;
  });
}
