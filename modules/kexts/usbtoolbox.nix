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
        type = with types; nullOr (either types.path types.str);
        default = null;
        description = ''
          Path to your newly created UTBMap.kext. Set to empty string ("") if it's already handled by `resources.KextsFolders`.
        '';
      };
    };
  };

  config = let
    usbtoolboxPackage = cfg.package.overrideAttrs (old: {
      preInstall =
        (old.preInstall or "") +
        (if (cfg.mapping != null) then ''
          rm -r ./UTB*.kext
        '' else "") +
        (if (cfg.mapping != null && (builtins.typeOf cfg.mapping) != "string") then ''
          cp -r ${cfg.mapping} ./UTBMap.kext
        '' else "");
    });
  in mkIf cfg.enable {
    kexts.usbtoolbox.finalPackage = usbtoolboxPackage;
    oceanix.opencore.resources.packages = [ usbtoolboxPackage ];
  };
}
