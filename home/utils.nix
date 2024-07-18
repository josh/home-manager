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
    rsync
    shellcheck
    shfmt
    unzip
    wget
  ];

  programs = {
    fd.enable = true;
    ripgrep.enable = true;
  };
}
