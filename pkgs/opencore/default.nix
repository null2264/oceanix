{ lib, pkgs }:

{
  opencore = (import ../stdPkger.nix {
    inherit lib pkgs;
    pname = "opencore";
    path = ./.;
  });
}
