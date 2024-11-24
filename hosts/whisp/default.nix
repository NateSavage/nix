{
  imports = [
    <nixos-wsl/modules>
    #./services

    ../common/core
    ../common/users/nate
  ];

  wsl.enable = true;
  wsl.defaultUser = "Nate";
}