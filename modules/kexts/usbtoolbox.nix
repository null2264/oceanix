{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.kexts.usbtoolbox;
in

{
  options = {
    kexts.usbtoolbox = {
      enable = mkEnableOption "USBToolBox";

      package = mkOption {
        type = types.package;
        default = pkgs.oc.usbtoolbox.latest;
        defaultText = literalExpression "pkgs.oc.usbtoolbox.latest";
        description = ''
          Package containing the USBToolBox Kext.
        '';
      };

      finalPackage = mkOption {
        type = types.package;
        readOnly = true;
        visible = false;
        description = ''
          Resulting USBToolBox package.
        '';
      };

      mapping = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Path to your newly created UTBMap.kext.
        '';
      };
    };
  };

  config = let
    usbtoolboxPackage = cfg.package.overrideAttrs (old: {
      preInstall =
        old.preInstall or "" +
        (if cfg.mapping != null then ''
          rm -r ./UTBDefault.kext
          cp -r ${cfg.mapping} ./
        '' else "");
    });
  in mkIf cfg.enable {
    kexts.usbtoolbox.finalPackage = usbtoolboxPackage;
    oceanix.opencore.resources.packages = [ usbtoolboxPackage ];
  };
}
