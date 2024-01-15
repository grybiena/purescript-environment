{
  description = "purescript-environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    ps-tools.follows = "purs-nix/ps-tools";
    purs-nix.url = "github:grybiena/purs-nix?ref=grybiena";
    npmlock2nix =
      { flake = false;
        url = "github:grybiena/npmlock2nix?ref=grybiena";
      };
  };
  outputs = inputs:
    with inputs;
    rec {
      inherit nixpkgs flake-utils ps-tools purs-nix npmlock2nix;
      gen-overlays = {
        __functor = _: { pkgs, system }: overlays:
        let overlayInput = name: input:
              if input ? packages
                then let pkg = input.packages.${system}.default;
                     in if pkg ? purs-nix-info then { "${name}" = pkg; } else {}
                else {};
          in [ (self: super: pkgs.lib.attrsets.concatMapAttrs overlayInput overlays) ];
      };
      build-package = {
        __functor = _: build@{ system, name, src, overlays, derive-package, shellHook ? "", pursuit ? {}, ... }:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ ];
              config.allowBroken = true;
            };
            purs-nix-overlay = purs-nix {
              inherit system; 
              overlays = with inputs; gen-overlays { inherit pkgs system; } overlays;
            };

            package = import derive-package (purs-nix-overlay // {
              npmlock2nix = import npmlock2nix { inherit pkgs; };
            }); 

            ps = purs-nix-overlay.purs package;


            shell = pkgs.mkShell
              { inherit shellHook;
                packages = with pkgs; [
                    nodejs
                    (ps.command {
                      inherit package;
#                      package = {
#                        inherit pursuit;
#                      };
                    }) 
                    ps-tools.legacyPackages.${system}.for-0_15.purescript-language-server
                    purs-nix-overlay.esbuild
                    purs-nix-overlay.purescript
                  ];
              };
          in { packages = {
                 default =
                   purs-nix-overlay.build
                     { inherit name; 
                       src.path = src;
                       info = package;
                     };
                 output = ps.output {};

               } // (if build ? bundle then { bundle = ps.bundle build.bundle; } else {});
               devShells.default = shell; 
             };
      };
    };
}
