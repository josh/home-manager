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
    nixfmt-rfc-style
    nodePackages.prettier
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
    fd.enable = true;
    ripgrep.enable = true;
  };
}
