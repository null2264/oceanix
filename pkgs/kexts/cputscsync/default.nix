{ lib, pkgs }:
{
  cputscsync = (import ../../stdPkger.nix {
    inherit lib pkgs;
    pname = "cputscsync";
    path = ./.;
  });
}
