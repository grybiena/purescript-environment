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

    crypto-secp256k1 = {
      url = "git+ssh://git@github.com/grybiena/crypto-secp256k1?ref=grybiena";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows     = "nixpkgs";
        ps-tools.follows    = "ps-tools";
        purs-nix.follows    = "purs-nix";
        npmlock2nix.follows = "npmlock2nix";
      };
    };
 
    mycelial-fibration = {
      url = "git+ssh://git@github.com/grybiena/mycelial-fibration?ref=grybiena";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows     = "nixpkgs";
        ps-tools.follows    = "ps-tools";
        purs-nix.follows    = "purs-nix";
        npmlock2nix.follows = "npmlock2nix";
        crypto-secp256k1.follows = "crypto-secp256k1";
      };
    };

    mycelial-socket = {
      url = "git+ssh://git@github.com/grybiena/mycelial-socket?ref=grybiena";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows     = "nixpkgs";
        ps-tools.follows    = "ps-tools";
        purs-nix.follows    = "purs-nix";
        crypto-secp256k1.follows = "crypto-secp256k1";
      };
    };

    mycelial-space = {
      url = "git+ssh://git@github.com/grybiena/mycelial-space?ref=grybiena";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows     = "nixpkgs";
        ps-tools.follows    = "ps-tools";
        purs-nix.follows    = "purs-nix";
        crypto-secp256k1.follows = "crypto-secp256k1";
      };
    };

    web-rtc = {
      url = "git+ssh://git@github.com/grybiena/web-rtc?ref=grybiena";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows     = "nixpkgs";
        ps-tools.follows    = "ps-tools";
        purs-nix.follows    = "purs-nix";
      };
    };


  };
  outputs = inputs@{ flake-utils, purs-nix, ...} :
    { __functor = _: { pkgs, system }:
        purs-nix {
          inherit system;
          overlays = let otherInputs = [ "nixpkgs" "flake-utils" "ps-tools" "purs-nix" "npmlock2nix" ];
                         overlayInput = name: input:
                           if pkgs.lib.lists.any (other: other == name) otherInputs
                             then {}
                             else { "${name}" = input.packages.${system}.default; };
                     in [ (self: super: pkgs.lib.attrsets.concatMapAttrs overlayInput inputs) ];
       };
    };
}


