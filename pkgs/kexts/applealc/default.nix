{ lib, pkgs }:

{
  applealc = (import ../../stdPkger.nix {
    inherit lib pkgs;
    pname = "applealc";
    path = ./.;
  });
}
