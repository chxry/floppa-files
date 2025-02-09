{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      fenix,
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      packages = forAllSystems (system: {
        default =
          with import nixpkgs { inherit system; };
          let
            toolchain = fenix.packages.${system}.minimal.toolchain;
            manifest = builtins.fromTOML (builtins.readFile ./Cargo.toml);
          in
          (pkgs.makeRustPlatform {
            cargo = toolchain;
            rustc = toolchain;
          }).buildRustPackage
            {
              pname = manifest.package.name;
              version = manifest.package.version;

              src = ./.;
              cargoLock.lockFile = ./Cargo.lock;
              nativeBuildInputs = [ pkgs.tailwindcss ];

              postInstall = ''
                cp -Lr static $out
              '';
            };
      });
    };
}
