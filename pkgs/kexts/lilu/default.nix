{ lib, pkgs }:

{
  lilu = (import ../../stdPkger.nix {
    inherit lib pkgs;
    pname = "lilu";
    path = ./.;
  });
}
