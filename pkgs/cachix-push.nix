{ patchShellScript, cachix }:
patchShellScript {
  scriptPath = ./cachix-push.sh;
  runtimeInputs = [ cachix ];
}
