{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  home-manager = {
    backupFileExtension = "backup";

    sharedModules = {
      # imports = [ ];
    };

    # TODO: Somehow allow default user to be set
    # users.josh = {
    #   imports = [ ];
    # };
  };
}
