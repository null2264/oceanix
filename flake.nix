{
  description = "OpenCore bootloader manager with Nix";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, utils, ... }: with utils.lib;
    rec {
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

      checks.x86_64-linux.buildExampleEfi = (self.lib.OpenCoreConfig {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ self.overlays.default ];
        };

        modules = [
          ({ lib, pkgs, ... }: {
            oceanix.opencore = {
              resources.packages = [
                pkgs.oc.airportitlwm.latest-ventura
                pkgs.oc.itlwm.v2_1_0  # FIXME: .latest is broken
                pkgs.oc.applealc.latest
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
    } // eachSystem [ system.i686-linux system.x86_64-linux system.x86_64-darwin ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = nixpkgs.lib;
      in
      {
        # FIXME: Make it support the new pkgs.oc.<package>.<version> format. currently <version> is derivation but <package> is not.
        # packages = (import ./pkgs { inherit lib pkgs; });

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
