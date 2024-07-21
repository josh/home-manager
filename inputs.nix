let
  rev = "4f910c9827911b1ec2bf26b5a062cd09f8d89f85";
  hash = "sha256:0x79lylianpvhyafv6267mhd94an0khjl8dzdmy3vl7yq3d3y100";
  path = fetchTarball {
    url = "https://github.com/edolstra/flake-compat/archive/${rev}.tar.gz";
    sha256 = hash;
  };
  flakeCompat = import path;
  flake = flakeCompat { src = ./.; };
in
flake.defaultNix.inputs
