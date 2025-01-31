{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  options.my = {
    username = lib.mkOption {
      description = "Primary user name";
      type = lib.types.str;
      default = "josh";
      example = "josh";
    };
  };

  config = {
    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        use-xdg-base-directories = true;
        accept-flake-config = true;
        substituters = [
          "https://cache.nixos.org"
          "https://josh.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "josh.cachix.org-1:qc8IeYlP361V9CSsSVugxn3o3ZQ6w/9dqoORjm0cbXk="
        ];
        extra-trusted-users = [ config.my.username ];
      };
    };

    users.users.${config.my.username} = {
      isNormalUser = true;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keyFiles = [
        "${inputs.dotfiles}/ssh/authorized_keys"
      ];
    };

    programs.zsh.enable = true;

    home-manager = {
      backupFileExtension = "backup";
    };
  };
}
