# See Nixpkgs: Build an environment section
# https://nixos.org/manual/nixpkgs/unstable/#sec-building-environment
{
  lib,
  buildEnv,
  josh,
  cachix,
  deadnix,
  devenv,
  git,
  hello,
  nh,
  nix-tree,
  nixd,
  nixfmt-rfc-style,
  nixos-generators,
  nurl,
  statix,
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
      hello
      josh.deadsymlinks
      josh.test-fonts
      josh.touch-cachedir-tag

      # git
      git
      josh.git-branch-prune
      josh.git-track

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
    ++ (lib.lists.optional (installationEnv == "nixos") josh.os-up)
    ++ (lib.lists.optional (installationEnv == "home-manager") josh.hm-up);

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
