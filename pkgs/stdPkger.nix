{ lib, pkgs, pname, path }:
import ./pkger.nix {
  inherit lib pkgs path;
  fn = ver:
    let
      versionInfo = (import (path + "/version.nix") { inherit lib; })."${ver}";
      version = versionInfo.canonicalVersion;
    in {
      "${ver}-debug" = pkgs.callPackage (path + "/${pname}.nix") {
        inherit version;
        hash = versionInfo.debug;
        release = false;
      };

      "${ver}" = pkgs.callPackage (path + "/${pname}.nix") {
        inherit version;
        hash = versionInfo.release;
      };
    };
}
