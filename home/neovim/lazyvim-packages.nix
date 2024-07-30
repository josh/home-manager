let
  discoverLazyVimPackageNamesDrv =
    { pkgs }:
    derivation {
      name = "LazyVim-packages.json";
      builder = "${pkgs.neovim}/bin/nvim";
      args = [
        "-l"
        ./lua/lazyvim-packages.lua
        pkgs.vimPlugins.lazy-nvim
        pkgs.vimPlugins.LazyVim
      ];
      inherit (pkgs) system;
    };
  discoverLazyVimPackageNames =
    { pkgs }:
    let
      jsonFile = discoverLazyVimPackageNamesDrv { inherit pkgs; };
      jsonData = builtins.readFile jsonFile;
      jsonSet = builtins.fromJSON jsonData;
    in
    jsonSet;

  # Look up nixpkgs.vimPlugins for GitHub repo name.
  # Return null if the package is not found.
  lookupPackage =
    { pkgs, repo }:
    let
      inherit (pkgs) vimPlugins;
      pluginName = builtins.replaceStrings [ "." ] [ "-" ] repo;
      ok = builtins.hasAttr pluginName vimPlugins;
      notFound = builtins.trace "pkgs.vimPlugins.${pluginName} not found" null;
    in
    if ok then vimPlugins."${pluginName}" else notFound;

  discoverLazyVimPackages =
    { pkgs }:
    let
      packageNames = discoverLazyVimPackageNames { inherit pkgs; };
      packageFound = _name: src: src != null;
      mapWithPkgs =
        _: repos:
        pkgs.lib.filterAttrs packageFound (
          pkgs.lib.attrsets.genAttrs repos (repo: lookupPackage { inherit pkgs repo; })
        );
    in
    builtins.mapAttrs mapWithPkgs packageNames;
in
{
  inherit discoverLazyVimPackageNames discoverLazyVimPackages;
}
