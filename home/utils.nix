{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cowsay
    curl
    du-dust
    dua
    duf
    fastfetch
    hello
    jq
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
    bottom.enable = true;
    btop.enable = true;
    fd.enable = true;
    ripgrep.enable = true;
  };
}
