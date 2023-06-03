{
  description = "purescript-environment";
  inputs = {
    get-flake.url = "github:ursi/get-flake";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    ps-tools.follows = "purs-nix/ps-tools";
    purs-nix.url = "github:grybiena/purs-nix?ref=grybiena";
    npmlock2nix =
      { flake = false;
        url = "github:grybiena/npmlock2nix?ref=grybiena";
      };
  };
  outputs = { flake-utils, ps-tools, ...} :
    flake-utils.lib.eachDefaultSystem (system: {
      packages.default = ps-tools.legacyPackages.${system}.purescript;
    });
}

