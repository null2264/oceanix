{ lib, pkgs }:
{
  debugenhancer = (import ../../stdPkger.nix {
    inherit lib pkgs;
    pname = "debugenhancer";
    path = ./.;
  });
}
