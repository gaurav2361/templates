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

          clojure = {
            path = ./templates/clojure;
            description = "Clojure development environment";
          };

          cue = {
            path = ./templates/cue;
            description = "Cue development environment";
          };

          deno = {
            path = ./templates/deno;
            description = "Deno development environment";
          };

          dhall = {
            path = ./templates/dhall;
            description = "Dhall development environment";
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

          gleam = {
            path = ./templates/gleam;
            description = "Gleam development environment";
          };

          go = {
            path = ./templates/go;
            description = "Go (Golang) development environment";
          };

          hashi = {
            path = ./templates/hashi;
            description = "HashiCorp DevOps tools development environment";
          };

          haskell = {
            path = ./templates/haskell;
            description = "Haskell development environment";
          };

          haxe = {
            path = ./templates/haxe;
            description = "Haxe development environment";
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

          latex = {
            path = ./templates/latex;
            description = "LaTeX development environment";
          };

          lean4 = {
            path = ./templates/lean4;
            description = "Lean 4 development environment";
          };

          nickel = {
            path = ./templates/nickel;
            description = "Nickel development environment";
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

          ocaml = {
            path = ./templates/ocaml;
            description = "OCaml development environment";
          };

          odin = {
            path = ./templates/odin;
            description = "Odin development environment";
          };

          opa = {
            path = ./templates/opa;
            description = "Open Policy Agent development environment";
          };

          php = {
            path = ./templates/php;
            description = "PHP development environment";
          };

          platformio = {
            path = ./templates/platformio;
            description = "PlatformIO development environment";
          };

          protobuf = {
            path = ./templates/protobuf;
            description = "Protobuf development environment";
          };

          pulumi = {
            path = ./templates/pulumi;
            description = "Pulumi development environment";
          };

          purescript = {
            path = ./templates/purescript;
            description = "Purescript development environment";
          };

          python = {
            path = ./templates/python;
            description = "Python development environment";
          };

          r = {
            path = ./templates/r;
            description = "R development environment";
          };

          ruby = {
            path = ./templates/ruby;
            description = "Ruby development environment";
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

          swi-prolog = {
            path = ./templates/swi-prolog;
            description = "Swi-prolog development environment";
          };

          swift = {
            path = ./templates/swift;
            description = "Swift development environment";
          };

          typst = {
            path = ./templates/typst;
            description = "Typst development environment";
          };

          vlang = {
            path = ./templates/vlang;
            description = "Vlang developent environment";
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
