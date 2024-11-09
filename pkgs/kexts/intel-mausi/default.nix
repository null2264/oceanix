{ lib, pkgs }:

{
  intel-mausi = (import ../../stdPkger.nix {
    inherit lib pkgs;
    pname = "intel-mausi";
    path = ./.;
  });
}
