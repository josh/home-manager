{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cowsay
    du-dust
    dua
    duf
    fd
    hello
    jq
    neofetch
    nixfmt-rfc-style
    nodePackages.prettier
    rclone
    restic
    ripgrep
    rsync
    shellcheck
    shfmt
    unzip
    wget
  ];
}
