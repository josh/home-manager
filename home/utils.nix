{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cowsay
    hello
    jq
    neofetch
    nixfmt-rfc-style
    nodePackages.prettier
    ripgrep
    shellcheck
    shfmt
    wget
  ];
}
