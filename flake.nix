{
  description = "Mathematical software packaged as a Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      forSystems =
        systems: function:
        nixpkgs.lib.genAttrs systems (
          system:
          function (
            import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            }
          )
        );
    in
    {
      packages = forSystems supportedSystems (pkgs: rec {
        mfaktc = pkgs.callPackage mfaktc/package.nix { };
        mfakto = pkgs.callPackage mfakto/package.nix { };
        prmers = pkgs.callPackage prmers/package.nix { };
        prpll = pkgs.callPackage prpll/package.nix { };
        default = prmers;
      });
    };
}
