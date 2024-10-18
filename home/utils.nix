{ pkgs, ... }:
{
  home.packages = with pkgs; [
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
    hello
    htop
    ipfetch
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

    josh.codespace-fix-tmp-permissions
    josh.deadsymlinks
    josh.touch-cachedir-tag
  ];

  programs = {
    btop.enable = true;
    fd.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
  };
}
