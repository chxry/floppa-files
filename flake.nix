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
      nixosModules.default =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        let
          cfg = config.services.floppa-files;
          pkg = self.packages.${pkgs.system}.default;
        in
        {
          options.services.floppa-files = {
            enable = lib.mkEnableOption "enable floppa files";
            max_size = lib.mkOption { default = 5000000000; };
            file_dir = lib.mkOption { default = "/var/lib/floppa-files"; };
            allow_empty_files = lib.mkOption { default = false; };
            prefix_length = lib.mkOption { default = 8; };
            port = lib.mkOption { default = 3000; };
            log_file = lib.mkOption { default = "/var/log/floppa-files.log"; };
          };

          config = lib.mkIf cfg.enable {
            systemd.services.floppa-files = {
              wantedBy = [ "multi-user.target" ];

              serviceConfig = {
                Restart = "on-failure";
                ExecStart = "${pkg}/bin/floppa-files";
                WorkingDirectory = pkg;
                Environment = "FLOPPA_CONFIG=${pkgs.writeText "config.toml" ''
                  max_size = ${toString cfg.max_size}
                  file_dir = "${cfg.file_dir}"
                  allow_empty_files = ${lib.boolToString cfg.allow_empty_files}
                  prefix_length = ${toString cfg.prefix_length}
                  listen = "0.0.0.0:${toString cfg.port}"
                  log_file = "${toString cfg.log_file}"
                ''}";
              };
            };
          };
        };
    };
}
