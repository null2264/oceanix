{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.kexts.virtualsmc;
in

{
  options = {
    kexts.virtualsmc = {
      enable = mkEnableOption "VirtualSMC";

      package = mkOption {
        type = types.package;
        default = pkgs.oc.virtualsmc.latest;
        defaultText = literalExpression "pkgs.oc.virtualsmc.latest";
        description = ''
          Package containing the VirtualSMC Kexts.
        '';
      };

      finalPackage = mkOption {
        type = types.package;
        readOnly = true;
        visible = false;
        description = ''
          Resulting VirtualSMC package.
        '';
      };

      includedPlugins =
        let
          # REF: https://github.com/acidanthera/VirtualSMC/tree/master/Sensors
          validValues =
            [
              "SMCBatteryManager"
              "SMCDellSensors"
              "SMCLightSensor"
              "SMCProcessor"
              "SMCSuperIO"
            ];
        in mkOption {
          # Unfortunately I can't seems to adjust typecheck error message...
          type = types.listOf types.str // { check = (x: builtins.elem false (builtins.map (v: builtins.elem v validValues) x) != true); };
          default = [];
          description = ''
            Which VirtualSMC (bundled) plugin(s) should be included on the EFI installation.
          '';
        };
    };
  };

  config = let
    virtualsmcPackage = cfg.package.overrideAttrs (old: {
      postInstall = ''
        ${old.postInstall or ""}

        # TODO: Remove excluded kexts
        echo "${builtins.concatStringsSep " " cfg.includedPlugins}"
        echo "'kexts.virtualsmc.enable = true' is not yet ready!"; exit 1;
      '';
    });
  in mkIf cfg.enable {
    kexts.virtualsmc.finalPackage = virtualsmcPackage;
    oceanix.opencore.resources.packages = [ virtualsmcPackage ];
  };
}
