{
  patchShellScript,
  acl,
}:
patchShellScript {
  scriptPath = ./codespace-fix-tmp-permissions.sh;
  runtimeInputs = [ acl ];
  platforms = [ "x86_64-linux" ];
}
