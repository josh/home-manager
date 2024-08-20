{ pkgs, ... }:
{
  home.packages = with pkgs; [
    acl
    coreutils
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
    tree
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
