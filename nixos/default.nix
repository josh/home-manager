{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.nixos.org"
        "https://josh.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "josh.cachix.org-1:qc8IeYlP361V9CSsSVugxn3o3ZQ6w/9dqoORjm0cbXk="
      ];
    };
  };

  home-manager = {
    backupFileExtension = "backup";

    # List of imports
    # sharedModules = [];

    # TODO: Somehow allow default user to be set
    # users.josh = {
    #   imports = [ ];
    # };
  };
}
