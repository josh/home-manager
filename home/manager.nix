# Configure home-manager meta options
_: {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Oldest supported state version.
  home.stateVersion = "24.05";

  # Let me do what I want!
  # Permits packages like GitHub Copilot.
  nixpkgs.config.allowUnfree = true;

  # Disable home-manager news message.
  news.display = "silent";
}
