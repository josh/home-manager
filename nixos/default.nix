{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      extra-substituters = [
        "https://josh.cachix.org"
      ];
      extra-trusted-public-keys = [
        "josh.cachix.org-1:qc8IeYlP361V9CSsSVugxn3o3ZQ6w/9dqoORjm0cbXk="
      ];
    };
  };

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
