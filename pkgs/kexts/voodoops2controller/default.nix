{ lib, pkgs }:

{
  voodoops2controller = (import ../../stdPkger.nix {
    inherit lib pkgs;
    pname = "voodoops2controller";
    path = ./.;
  });
}
