{
  description = "Mathematical software packaged as a Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      # System types to support.
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      # Helper function
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        }
      );
    in
    {
      # A Nixpkgs overlay.
      overlays.default = final: prev: {
        prmers =
          with final;
          stdenv.mkDerivation (finalAttrs: {
            pname = "prmers";
            version = "4.0.22-alpha";
            src = fetchFromGitHub {
              owner = "cherubrock-seb";
              repo = "prmers";
              rev = "v${finalAttrs.version}";
              sha256 = "sha256-Rnt2nlI+4GyuB7EoGUiYqhxvUhBkNZoO40hWcI4v3d8=";
            };

            buildInputs = [
              curl
              ocl-icd
              opencl-headers
            ];

            PREFIX = placeholder "out";

            enableParallelBuilding = true;

            meta = {
              description = "GPU-accelerated Mersenne Primality Test";
              longDescription = ''
                PrMers is a high-performance GPU application for testing the primality
                of Mersenne numbers using the Lucas–Lehmer and PRP (Probable Prime)
                algorithms. It leverages OpenCL and Number Theoretic Transforms (NTT)
                for fast large-integer arithmetic, and is optimized for long-running
                computations.
              '';
              homepage = "https://www.mersenneforum.org/node/1074417";
              license = lib.licenses.mit;
              platforms = supportedSystems;
              mainProgram = "prmers";
            };
          });
      };

      packages = forAllSystems (system: {
        inherit (nixpkgsFor.${system}) prmers;
      });

      nixosModules.prmers =
        { pkgs, ... }:
        {
          environment.systemPackages = [ pkgs.prmers ];
        };
    };
}
