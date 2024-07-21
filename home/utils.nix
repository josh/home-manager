{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cowsay
    du-dust
    dua
    duf
    fastfetch
    hello
    jq
    nh
    nixfmt-rfc-style
    nodePackages.prettier
    nurl
    rclone
    restic
    rsync
    ruff
    shellcheck
    shfmt
    unzip
    uv
    wget
  ];

  programs = {
    bottom.enable = true;
    fd.enable = true;
    ripgrep.enable = true;
  };
}
