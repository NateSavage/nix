{
  imports = [
    <nixos-wsl/modules>
    #./services

    ../common/core
    ../../users/nate
  ];

  wsl.enable = true;
  wsl.defaultUser = "Nate";
}