{ lib, pkgs }:
{
  voodoormi = (import ../../pkger.nix {
    inherit lib pkgs;
    path = ./.;
    fn = ver:
      let
        verInfo = (import ./version.nix { inherit lib; });
        canonicalVersion = verInfo."${ver}".canonicalVersion;
        mkType = x: if (x == "Release") then "" else "-${lib.strings.toLower x}";
      in
      lib.attrsets.mapAttrs'
        (type: hash: lib.attrsets.nameValuePair (ver + (mkType type)) (pkgs.callPackage ./cpufriend.nix {
          inherit type hash canonicalVersion;
          version = canonicalVersion;
          versionName = ver;
        }))
        verInfo."${ver}".types;
  });
}
