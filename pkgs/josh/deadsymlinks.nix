{
  patchShellScript,
  findutils,
}:
patchShellScript {
  scriptPath = ./deadsymlinks.sh;
  runtimeInputs = [ findutils ];

}
