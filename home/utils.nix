{ pkgs, ... }:
{
  home.packages = with pkgs; [
    acl
    coreutils
    cowsay
    cpufetch
    curl
    du-dust
    dua
    duf
    fastfetch
    file
    hello
    htop
    ipfetch
    jq
    neofetch
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
  ];

  programs = {
    bottom.enable = true;
    btop.enable = true;
    fd.enable = true;
    ripgrep.enable = true;
  };
}
