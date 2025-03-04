{ lib, pkgs }:
{
  restrictevents = (import ../../stdPkger.nix {
    inherit lib pkgs;
    pname = "restrictevents";
    path = ./.;
  });
}
