{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cowsay
    du-dust
    dua
    duf
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

  programs = {
    fd.enable = true;
  };
}
