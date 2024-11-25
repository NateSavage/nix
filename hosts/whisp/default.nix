{
  imports = [
    ../common/required
    ../../users/nate

    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = "Nate";
}