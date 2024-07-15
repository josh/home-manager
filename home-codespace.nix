{ config, pkgs, ... }:

{
  home.username = "codespace";
  home.homeDirectory = "/home/codespace";
  imports = [ ./home.nix ];
}
