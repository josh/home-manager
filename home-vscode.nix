{ config, pkgs, ... }:

{
  home.username = "vscode";
  home.homeDirectory = "/home/vscode";
  imports = [ ./home.nix ];
}
