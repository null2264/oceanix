{ lib, pkgs }:

{
  rtcmemoryfixup = (import ../../stdPkger.nix {
    inherit lib pkgs;
    pname = "rtcmemoryfixup";
    path = ./.;
  });
}
