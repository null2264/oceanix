{
  description = "OpenCore bootloader manager with Nix";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, utils, ... }: with utils.lib;
    rec {
      systems = [ system.i686-linux system.x86_64-linux system.x86_64-darwin ];

      lib = {
        oc = (import ./lib/stdlib-extended.nix nixpkgs.lib).oc;
        OpenCoreConfig =
          { modules ? [ ]
          , pkgs
          , lib ? pkgs.lib
          , extraSpecialArgs ? { }
          , check ? true
          }@args:
          (import ./modules {
            inherit pkgs lib check extraSpecialArgs;
            configuration = { ... }: { imports = modules; };
          });
      };

      overlays.default = final: prev: {
        oc = (import ./pkgs {
          inherit (prev) lib;
          pkgs = prev;
        });
      };
    } // eachSystem [ system.i686-linux system.x86_64-linux system.x86_64-darwin ] (system: {
      checks.buildExampleEfi = (self.lib.OpenCoreConfig {
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };

        modules = [
          ({ lib, pkgs, ... }: {
            kexts.applealc = {
              enable = true;
              type = "alcu";
            };

            oceanix.opencore = {
              validate = false;  # Ignore validation for sample
              resources.packages = [
                pkgs.oc.airportitlwm.latest-ventura
                pkgs.oc.itlwm.latest
                pkgs.oc.brightnesskeys.latest
                pkgs.oc.ecenabler.latest
                pkgs.oc.intel-bluetooth-firmware.latest
                pkgs.oc.nvmefix.latest
                pkgs.oc.virtualsmc.latest
                pkgs.oc.whatevergreen.latest
                pkgs.oc.lilu.latest
                pkgs.oc.voodooi2c.latest
                pkgs.oc.voodoops2controller.latest
                pkgs.oc.intel-mausi.latest
              ];
            };
          })
        ];
      }).efiPackage;
    }) // eachSystem [ system.i686-linux system.x86_64-linux system.x86_64-darwin ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = nixpkgs.lib;
        ocPkgs = import ./pkgs { inherit lib pkgs; };

        # REF: https://github.com/NixOS/nixpkgs/pull/221608
        collect' =
        pred:
        f:
        attrs:
          let
            recurse = prefix: attrs:
              builtins.concatMap
                (name: visit (prefix ++ [ name ]) attrs.${name})
                (builtins.attrNames attrs);
            visit = path': value:
              if pred path' value then
                [ (f path' value) ]
              else if builtins.isAttrs value then
                recurse path' value
              else
                [ ];
          in
          visit [ ] attrs;

        # REF: https://github.com/NixOS/nixpkgs/pull/221608
        flattenAttrs = # pkgslib.flattenAttrs  # FIXME: Uncomment once GH-221608 is merged
        pred:
        f:
        attrs:
          if pred attrs then attrs
          else
            builtins.listToAttrs (map (x: pkgs.lib.nameValuePair (f x.path) x.value) (collect'
              (_: v: pred v || !builtins.isAttrs v)
              (path: value: { inherit path value; })
              attrs));
      in
      {
        packages = flattenAttrs pkgs.lib.isDerivation (builtins.concatStringsSep "-") ocPkgs;

        apps = rec {
          fmt = utils.lib.mkApp {
            drv = with import nixpkgs { inherit system; };
              pkgs.writeShellScriptBin "oceanix-fmt" ''
                export PATH=${
                  pkgs.lib.strings.makeBinPath [
                    findutils
                    nixpkgs-fmt
                    shfmt
                    shellcheck
                  ]
                }
                find . -type f -name '*.sh' -exec shellcheck {} +
                find . -type f -name '*.sh' -exec shfmt -w {} +
                find . -type f -name '*.nix' -exec nixpkgs-fmt {} +
              '';
          };
          default = fmt;
        };
      });
}
