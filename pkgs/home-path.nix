{
  buildEnv,
  cachix,
  deadnix,
  deadsymlinks,
  devenv,
  git-branch-prune,
  git-track,
  git,
  hello,
  nh,
  nix-tree,
  nixd,
  nixfmt-rfc-style,
  nixos-generators,
  nurl,
  statix,
  test-fonts,
  touch-cachedir-tag,
}:
buildEnv {
  name = "home-path";
  paths = [
    deadsymlinks
    hello
    test-fonts
    touch-cachedir-tag

    # git
    git
    git-branch-prune
    git-track

    # nix tools
    cachix
    deadnix
    devenv
    nh
    nix-tree
    nixd
    # nixfmt
    nixfmt-rfc-style
    nixos-generators
    nurl
    statix
  ];
}
