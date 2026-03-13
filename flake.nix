{
  description = "Ready-made templates for easily creating flake-driven environments";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";

  outputs =
    { self, ... }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            inherit system;
            pkgs = import inputs.nixpkgs { inherit system; };
          }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs, system }:
        {
          default =
            let
              getSystem = "SYSTEM=$(nix eval --impure --raw --expr 'builtins.currentSystem')";
              forEachDir = exec: ''
                for dir in */; do
                  (
                    cd "''${dir}"

                    ${exec}
                  )
                done
              '';

              script =
                name: runtimeInputs: text:
                pkgs.writeShellApplication {
                  inherit name runtimeInputs text;
                  bashOptions = [
                    "errexit"
                    "pipefail"
                  ];
                };
            in
            pkgs.mkShellNoCC {
              packages =
                with pkgs;
                [
                  (script "build" [ ] ''
                    ${getSystem}

                    ${forEachDir ''
                      echo "building ''${dir}"
                      nix build ".#devShells.''${SYSTEM}.default"
                    ''}
                  '')
                  (script "check" [ nixfmt ] (forEachDir ''
                    echo "checking ''${dir}"
                    nix flake check --all-systems --no-build
                  ''))
                  (script "format" [ nixfmt ] ''
                    git ls-files '*.nix' | xargs nix fmt
                  '')
                  (script "check-formatting" [ nixfmt ] ''
                    git ls-files '*.nix' | xargs nixfmt --check
                  '')
                ]
                ++ [ self.formatter.${system} ];
            };
        }
      );

      formatter = forEachSupportedSystem ({ pkgs, ... }: pkgs.nixfmt);

      packages = forEachSupportedSystem (
        { pkgs, ... }:
        rec {
          default = dvt;
          dvt = pkgs.writeShellApplication {
            name = "dvt";
            bashOptions = [
              "errexit"
              "pipefail"
            ];
            text = ''
              if [ -z "''${1}" ]; then
                echo "no template specified"
                exit 1
              fi

              TEMPLATE=$1

              nix \
                --experimental-features 'nix-command flakes' \
                flake init \
                --template \
                "github:gaurav2361/templates#''${TEMPLATE}"
            '';
          };
        }
      );
    }

    //

      {
        templates = rec {
          default = empty;

          bun = {
            path = ./templates/bun;
            description = "Bun development environment";
          };

          c-cpp = {
            path = ./templates/c-cpp;
            description = "C/C++ development environment";
          };

          deno = {
            path = ./templates/deno;
            description = "Deno development environment";
          };

          elixir = {
            path = ./templates/elixir;
            description = "Elixir development environment";
          };

          elm = {
            path = ./templates/elm;
            description = "Elm development environment";
          };

          empty = {
            path = ./templates/empty;
            description = "Empty dev template that you can customize at will";
          };

          go = {
            path = ./templates/go;
            description = "Go (Golang) development environment";
          };

          hashi = {
            path = ./templates/hashi;
            description = "HashiCorp DevOps tools development environment";
          };

          java = {
            path = ./templates/java;
            description = "Java development environment";
          };

          jupyter = {
            path = ./templates/jupyter;
            description = "Jupyter development environment";
          };

          kotlin = {
            path = ./templates/kotlin;
            description = "Kotlin development environment";
          };

          laravel = {
            path = ./templates/laravel;
            description = "Laravel development environment";
          };

          nim = {
            path = ./templates/nim;
            description = "Nim development environment";
          };

          nix = {
            path = ./templates/nix;
            description = "Nix development environment";
          };

          node = {
            path = ./templates/node;
            description = "Node.js development environment";
          };

          odin = {
            path = ./templates/odin;
            description = "Odin development environment";
          };

          php = {
            path = ./templates/php;
            description = "PHP development environment";
          };

          python = {
            path = ./templates/python;
            description = "Python development environment";
          };

          rust = {
            path = ./templates/rust;
            description = "Rust development environment";
          };

          scala = {
            path = ./templates/scala;
            description = "Scala development environment";
          };

          shell = {
            path = ./templates/shell;
            description = "Shell script development environment";
          };

          swift = {
            path = ./templates/swift;
            description = "Swift development environment";
          };

          uv = {
            path = ./templates/uv;
            description = "Python (uv) development environment";
          };

          zig = {
            path = ./templates/zig;
            description = "Zig development environment";
          };

          # Aliases
          c = c-cpp;
          cpp = c-cpp;
        };
      };
}
