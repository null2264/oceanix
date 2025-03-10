{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.oceanix;
  plistFile = oc.plist.toPlist { } cfg.opencore.transposedSettings;
  resources = cfg.opencore.resources;
  sampleConfig = oc.resolver.parsePlist pkgs "${cfg.opencore.package}/Docs/Sample.plist";
in
{
  options.oceanix = {
    efiPackage = mkOption {
      internal = true;
      type = types.package;
      description = "The package containing the complete EFI folder";
    };

    efiIntermediatePackage = mkOption {
      internal = true;
      type = types.package;
      description = "The package containing everything but the config in EFI";
    };

    opencore = {
      arch = mkOption {
        type = types.enum [ "IA32" "X64" ];
        default = "X64";
        description = "The architecture to install OpenCore with";
      };

      autoEnablePlugins = mkOption {
        type = types.bool;
        default = true;
        description =
          "Whether to automatically enable plugins of one kexts if which gets enabled";
      };

      autoEnableACPI = mkOption {
        type = types.bool;
        default = false;
        description =
          "Whether to automatically enable ACPI patches";
      };

      autoEnableDrivers = mkOption {
        type = types.bool;
        default = false;
        description =
          "Whether to automatically enable drivers";
      };

      autoEnableTools = mkOption {
        type = types.bool;
        default = false;
        description =
          "Whether to automatically enable tools";
      };

      useSampleAsDefault = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to use values from Sample.plist as defaults for certain sections of settings. See README for sections details";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.oc.opencore.latest;
        description = "The OpenCore package to use";
      };

      transposedSettings = mkOption {
        internal = true;
        type = types.attrsOf types.anything;
        description = "Transposed final OpenCore config";
      };

      settings = mkOption {
        type = types.attrsOf types.anything;
        description = "The OpenCore config written in Nix";
      };

      resources = {
        packages = mkOption {
          type = with types; listOf package;
          default = [ ];
          description =
            "External resources like Kext, Drivers, ACPI files to copy into the final package.";
        };

        ACPIFolders = mkOption {
          type = with types; listOf path;
          default = [ ];
          description =
            "ACPI folders to be copied into the final package, used along with resources.packages";
        };

        KextsFolders = mkOption {
          type = with types; listOf path;
          default = [ ];
          description =
            "Kext folders to be copied into the final package, used along with resources.packages";
        };

        DriversFolders = mkOption {
          type = with types; listOf path;
          default = [ ];
          description =
            "Drivers folders to be copied into the final package, used along with resources.packages";
        };

        ToolsFolders = mkOption {
          type = with types; listOf path;
          default = [ ];
          description =
            "Tools folders to be copied into the final package, used along with resources.packages";
        };
      };

      validate = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to automatically validate generated Config.plist with ocvalidate";
      };
    };
  };

  config = mkMerge [{
    oceanix.opencore.settings = with oc.resolver; {
      ACPI.Add = mkDefaultRecursive (mkACPI cfg.opencore.autoEnableACPI cfg.efiIntermediatePackage);
      UEFI.Drivers = mkDefaultRecursive (mkDrivers cfg.opencore.autoEnableDrivers cfg.efiIntermediatePackage);
      Misc.Tools = mkDefaultRecursive (mkTools cfg.opencore.autoEnableTools cfg.efiIntermediatePackage);
      Kernel.Add = mkDefaultRecursive (mkKexts pkgs cfg.efiIntermediatePackage);
    };

    oceanix.opencore.transposedSettings = with oc.resolver; updateManyAttrsByPath
      [
        {
          path = [ "Kernel" "Add" ];
          update = old: finalizeKexts cfg.opencore.autoEnablePlugins old;
        }
        { path = [ "Misc" "Tools" ]; update = old: transpose old; }
        { path = [ "UEFI" "Drivers" ]; update = old: transpose old; }
        { path = [ "ACPI" "Add" ]; update = old: finalizeACPI old; }
      ]
      cfg.opencore.settings;

    oceanix.efiIntermediatePackage =
      pkgs.runCommand "buildEfiIntermediate" { allowSubstitutes = false; } ''
        mkdir -p $out/

        cp -r --no-preserve=ownership,mode ${cfg.opencore.package}/${cfg.opencore.arch}/EFI $out

        ${concatStringsSep "\n" (lib.lists.map (pkg:
          if (builtins.pathExists "${pkg}/Kexts") && (builtins.readDir "${pkg}/Kexts" != {}) then
            "cp -r --no-preserve=ownership,mode ${pkg}/Kexts/* $out/EFI/OC/Kexts/"
          else
            "") resources.packages)}
        ${concatStringsSep "\n" (lib.lists.map (pkg:
          if (builtins.pathExists "${pkg}/ACPI") && (builtins.readDir "${pkg}/ACPI" != {}) then
            "cp --no-preserve=ownership,mode ${pkg}/ACPI/*.aml $out/EFI/OC/ACPI/"
          else
            "") resources.packages)}
        ${concatStringsSep "\n" (lib.lists.map (pkg:
          if (builtins.pathExists "${pkg}/Drivers") && (builtins.readDir "${pkg}/Drivers" != {}) then
            "cp --no-preserve=ownership,mode ${pkg}/Drivers/*.efi $out/EFI/OC/Drivers/"
          else
            "") resources.packages)}
        ${concatStringsSep "\n" (lib.lists.map (pkg:
          if (builtins.pathExists "${pkg}/Tools") && (builtins.readDir "${pkg}/Tools" != {}) then
            "cp --no-preserve=ownership,mode ${pkg}/Tools/*.efi $out/EFI/OC/Tools/"
          else
            "") resources.packages)}


        ${concatStringsSep "\n" (lib.lists.map (dir:
          if (builtins.readDir dir) != {} then
            ''
            cp --no-preserve=ownership,mode -t $out/EFI/OC/ACPI/ ${dir}/*.dsl 2>/dev/null || echo -n
            cp --no-preserve=ownership,mode -t $out/EFI/OC/ACPI/ ${dir}/*.aml 2>/dev/null || echo -n

            find $out/EFI/OC/ACPI/ -type f -name "*.dsl" -exec ${pkgs.acpica-tools}/bin/iasl \{\} \; -exec rm \{\} \;
            ''
          else
            "") resources.ACPIFolders)}

        ${concatStringsSep "\n" (lib.lists.map (dir:
          if (builtins.readDir dir) != {} then
            "cp --no-preserve=ownership,mode ${dir}/*.efi $out/EFI/OC/Tools/"
          else
            "") resources.ToolsFolders)}

        ${concatStringsSep "\n" (lib.lists.map (dir:
          if (builtins.readDir dir) != {} then
            "cp --no-preserve=ownership,mode ${dir}/*.efi $out/EFI/OC/Drivers/"
          else
            "") resources.DriversFolders)}

        ${concatStringsSep "\n" (lib.lists.map (dir:
          if (builtins.readDir dir) != {} then
            "cp -r --no-preserve=ownership,mode ${dir}/* $out/EFI/OC/Kexts/"
          else
            "") resources.KextsFolders)}
      '';

    oceanix.efiPackage = pkgs.runCommand "buildEfi" { allowSubstitutes = false; } (''
      mkdir -p $out/

      cp -r --no-preserve=ownership,mode ${cfg.efiIntermediatePackage}/EFI $out

      echo "${plistFile}" > $out/EFI/OC/Config.plist
    '' + pkgs.lib.optionalString cfg.opencore.validate ''
      ${cfg.opencore.package}/Utilities/ocvalidate/${if pkgs.stdenv.isDarwin then "ocvalidate" else "ocvalidate.linux"} $out/EFI/OC/Config.plist
    '');
  }
    {
      # These sections are good-defaults from Sample.plist
      # NOTE: their data type should not be Data or Date as those types are lost during parsing.
      # If it happens that some are of data or date type, we shall manually patch them up.
      oceanix.opencore.settings = with oc.resolver; let update = old: oc.plist.mkData old; in mkIf cfg.opencore.useSampleAsDefault (mkDefaultRecursive {
        ACPI.Quirks = sampleConfig.ACPI.Quirks;
        Booter.Quirks = sampleConfig.Booter.Quirks;
        Kernel = {
          inherit (sampleConfig.Kernel) Quirks Scheme;
          Emulate = updateManyAttrsByPath [
            { path = [ "Cpuid1Data" ]; inherit update; }
            { path = [ "Cpuid1Mask" ]; inherit update; }
          ]
            sampleConfig.Kernel.Emulate;
        };
        Misc = {
          inherit (sampleConfig.Misc) BlessOverride Boot Debug Serial;
          Security = updateManyAttrsByPath [
            { path = [ "PasswordHash" ]; inherit update; }
            { path = [ "PasswordSalt" ]; inherit update; }
          ]
            sampleConfig.Misc.Security;
        };
        NVRAM = {
          inherit (sampleConfig.NVRAM) Delete LegacyOverwrite LegacySchema WriteFlash;
          Add = updateManyAttrsByPath [
            { path = [ "4D1EDE05-38C7-4A6A-9CC6-4BCCA8B38C14" "DefaultBackgroundColor" ]; inherit update; }
            { path = [ "4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102" "rtc-blacklist" ]; inherit update; }
            { path = [ "7C436110-AB2A-4BBB-A880-FE41995C9F82" "SystemAudioVolume" ]; inherit update; }
            { path = [ "7C436110-AB2A-4BBB-A880-FE41995C9F82" "csr-active-config" ]; inherit update; }
            # Often users set this option to string type, we shall leave it as the string type to avoid type conflict.
            # { path = [ "7C436110-AB2A-4BBB-A880-FE41995C9F82" "prev-lang:kbd" ]; inherit update; }
          ]
            sampleConfig.NVRAM.Add;
        };
        PlatformInfo = {
          inherit (sampleConfig.PlatformInfo) Automatic CustomMemory UpdateDataHub UpdateNVRAM UpdateSMBIOS UpdateSMBIOSMode UseRawUuidEncoding;
          Generic = {
            inherit (sampleConfig.PlatformInfo.Generic) AdviseFeatures MaxBIOSVersion ProcessorType SpoofVendor SystemMemoryStatus;
          };
        };
        UEFI = {
          inherit (sampleConfig.UEFI) APFS AppleInput Audio ConnectDrivers Input Output ProtocolOverrides Quirks;
          ReservedMemory = [ ];
          Unload = [ ];
        };
      });
    }];
}
