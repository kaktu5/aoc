{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    inherit (nixpkgs) lib;
    forEachSystem = systems: f: let
      perSystemOutputs = lib.attrsets.genAttrs systems f;
      outputTypes = perSystemOutputs |> lib.attrsets.attrValues |> lib.lists.head |> lib.attrsets.attrNames;
    in
      lib.attrsets.genAttrs outputTypes (outputType:
        perSystemOutputs |> lib.attrsets.mapAttrs (_: attrs: attrs.${outputType}));
  in
    forEachSystem ["aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux"] (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = pkgs.mkShell {
        packages = lib.attrsets.attrValues {
          inherit (pkgs) deadnix nil nixd statix;
          inherit (pkgs.haskellPackages) fourmolu haskell-language-server;
          ghc' = pkgs.haskellPackages.ghcWithPackages (pkgs': [pkgs'.split]);
        };
      };

      formatter = pkgs.writeShellApplication {
        name = "fmt";
        runtimeInputs = lib.attrsets.attrValues {
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
