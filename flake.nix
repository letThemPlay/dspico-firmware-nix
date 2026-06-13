{
  description = "Flake for compiling DSPico firmware";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    blocksds-nix = {
      url = "github:pgattic/blocksds-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      flake-parts,
      blocksds-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          pkgs,
          system,
          ...
        }:
        {
          _module.args.pkgs = import self.inputs.nixpkgs {
            inherit system;
            overlays = [ blocksds-nix.overlays.default ];
            config.allowUnfree = true;
          };

          packages =
            let
              dsromencryptor = pkgs.callPackage ./pkgs/dsromencryptor {
                srcDir = self;
              };

              dspico-dldi = pkgs.callPackage ./pkgs/dspico/dldi { };

              dspico-wrfuxxed = pkgs.callPackage ./pkgs/dspico/wrfuxxed {
                inherit dspico-dldi;
              };

              dspico-bootloader = pkgs.callPackage ./pkgs/dspico/bootloader {
                inherit dspico-dldi dsromencryptor;
              };

            in
            pkgs.callPackage ./pkgs/dspico/firmware {
              inherit dspico-bootloader dspico-wrfuxxed;
              srcDir = self;
            };
        };
    };
}
