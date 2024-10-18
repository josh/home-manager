{
  lib,
  buildEnv,
  cachix,
  deadnix,
  deadsymlinks,
  devenv,
  git-branch-prune,
  git-track,
  git,
  hello,
  hm-up,
  nh,
  nix-tree,
  nixd,
  nixfmt-rfc-style,
  nixos-generators,
  nurl,
  os-up,
  statix,
  test-fonts,
  touch-cachedir-tag,
  installationEnv ? null,
}:
assert lib.asserts.assertOneOf "installationEnv" installationEnv [
  null
  "home-manager"
  "nixos"
];
buildEnv {
  name = "home-path";
  paths =
    [
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
    ]
    ++ (lib.lists.optional (installationEnv == "nixos") os-up)
    ++ (lib.lists.optional (installationEnv == "home-manager") hm-up);

  pathsToLink = [
    "/bin"
    "/share"
  ];
  extraOutputsToInstall = [
    "doc"
    "man"
  ];

  postBuild = ''
    # Remove wrapped binaries, they shouldn't be accessible via PATH.
    find $out/bin -maxdepth 1 -name ".*-wrapped" -type l -delete
  '';
}
