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
    { inherit nixpkgs flake-utils ps-tools purs-nix npmlock2nix;
      gen-overlays = {
        __functor = _: { pkgs, system }: overlays:
          let overlayInput = name: input: { "${name}" = input.packages.${system}.default; };
          in [ (self: super: pkgs.lib.attrsets.concatMapAttrs overlayInput overlays) ];
      };
    };
}
