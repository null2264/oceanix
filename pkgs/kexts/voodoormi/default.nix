{ lib, pkgs }:
{
  voodoormi = (import ../../pkger.nix {
    inherit lib pkgs;
    path = ./.;
    fn = ver:
      let
        verInfo = (import ./version.nix { inherit lib; });
        canonicalVersion = verInfo."${ver}".canonicalVersion;
      in
      lib.attrsets.mapAttrs'
        (type: hash: lib.attrsets.nameValuePair "${ver}-${lib.strings.toLower type}" (pkgs.callPackage ./voodoormi.nix {
          inherit type hash canonicalVersion;
          version = canonicalVersion;
          versionName = ver;
        }))
        verInfo."${ver}".types;
  });
}
