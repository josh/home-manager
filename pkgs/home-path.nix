{
  buildEnv,
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

    git
    git-branch-prune
    git-track

    deadnix
    devenv
    nh
    nix-tree
    nixd
    nixfmt-rfc-style
    statix
  ];
}
