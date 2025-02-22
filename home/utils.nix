{
  pkgs,
  inputs,
  ...
}:
let
  inherit (pkgs) system;
  inherit (inputs.lazy-nvim-nix.packages.${system}) LazyVim;

in
{
  home.packages = with pkgs; [
    # keep-sorted start
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
    nixbits.deadsymlinks
    nixbits.touch-cachedir-tag
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
    # keep-sorted end
  ];

  programs = {
    btop.enable = true;
    fd.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
  };
}
