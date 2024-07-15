{ config, pkgs, ... }:

{
  home.username = "runner";
  home.homeDirectory = "/home/runner";
  imports = [ ./home.nix ];
}
