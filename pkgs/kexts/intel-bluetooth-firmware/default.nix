{ lib, pkgs }:

{
  intel-bluetooth-firmware = (import ../../pkger.nix {
    inherit lib pkgs;
    path = ./.;
    fn = ver: {
      "${ver}" =
        pkgs.callPackage ./intel-bluetooth-firmware.nix { inherit ver; };
    };
  });
}
