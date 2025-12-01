{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    inherit (nixpkgs.lib.attrsets) attrValues mapAttrs recursiveUpdate;
    inherit (nixpkgs.lib.lists) foldl';

    mapSystems = systems: f: (foldl' (acc: system: (f system
      |> mapAttrs (_: value: {${system} = value;})
      |> recursiveUpdate acc)) {}
    systems);
    mapSystems' = mapSystems ["aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux"];
  in
    mapSystems' (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = pkgs.mkShell {
        name = "aoc-devshell";
        packages = attrValues {
          # haskell tooling
          ghc' = pkgs.haskellPackages.ghcWithPackages (pkgs': (attrValues {
            inherit
              (pkgs')
              flow
              split
              ;
          }));
          inherit
            (pkgs.haskellPackages)
            fourmolu
            haskell-language-server
            ;

          # nix tooling
          inherit
            (pkgs)
            deadnix
            nil
            nixd
            statix
            ;
        };
      };

      formatter = pkgs.writeShellApplication {
        name = "aoc-nix3-fmt-wrapper";
        runtimeInputs = attrValues {
          inherit (pkgs) alejandra fd;
          inherit (pkgs.haskellPackages) fourmolu;
        };
        text = ''
          fd "$@" -t f -e hs -X fourmolu --mode inplace --quiet '{}'
          fd "$@" -t f -e nix -X alejandra --quiet '{}'
        '';
      };
    });
}