{
  buildEnv,
  deadsymlinks,
  git-branch-prune,
  git-track,
  git,
  hello,
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
  ];
}
