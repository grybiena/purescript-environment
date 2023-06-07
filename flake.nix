{
  description = "purescript-environment";
  inputs = {
  };
  outputs = _:
    { __functor = _: { pkgs, system }: overlays:
        let overlayInput = name: input: { "${name}" = input.packages.${system}.default; };
        in [ (self: super: pkgs.lib.attrsets.concatMapAttrs overlayInput overlays) ];
    };
}
