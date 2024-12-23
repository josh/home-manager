{
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (pkgs) system;
  inherit (inputs.lazy-nvim-nix.packages.${system}) LazyVim;

in
{
  home.packages = with pkgs; [
    LazyVim
    acl
    age
    age-plugin-tpm
    age-plugin-yubikey
    coreutils
    cowsay
    cpufetch
    curl
    du-dust
    dua
    duf
    fastfetch
    file
    helix
    hello
    htop
    ipfetch
    nodePackages.prettier
    onefetch
    python3
    ramfetch
    rclone
    restic
    rsync
    ruff
    shellcheck
    shfmt
    speedtest-rs
    tree
    unzip
    uv
    wget

    (
      if config.home.username == "codespace" || config.home.username == "vscode" then
        josh.codespace-fix-tmp-permissions
      else
        # TODO: Find better way to no-op pkg
        hello
    )
    nixbits.deadsymlinks
    josh.touch-cachedir-tag
  ];

  programs = {
    btop.enable = true;
    fd.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
  };
}
