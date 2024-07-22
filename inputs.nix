let
  rev = "38fd3954cf65ce6faf3d0d45cd26059e059f07ea";
  hash = "sha256:1lgx0c0n0hw1ds1in497w3c86ki0iksi59h6daphpl7rj5w65f8n";
  path = fetchTarball {
    url = "https://github.com/nix-community/flake-compat/archive/${rev}.tar.gz";
    sha256 = hash;
  };
  flakeCompat = import path;
  flake = flakeCompat { src = ./.; };
in
flake.defaultNix.inputs
