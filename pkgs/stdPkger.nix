{ lib, pkgs, pname, path }:
import ./pkger.nix {
  inherit lib pkgs path;
  fn = ver: {
    "${ver}-debug" = pkgs.callPackage (path + "/${pname}.nix") {
      inherit ver;
      release = false;
    };

    "${ver}" =
      pkgs.callPackage (path + "/${pname}.nix") { inherit ver; };
  };
}
