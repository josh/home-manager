{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cowsay
    du-dust
    dua
    duf
    fastfetch
    hello
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
    jq.enabled = true;
    ripgrep.enable = true;
  };
}
