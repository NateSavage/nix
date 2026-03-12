{ pkgsUnstable, ... } : {

  #nixpkgs.config.permittedInsecurePackages = [
  #  "dotnet-sdk-6.0.428"
  #];

  environment.systemPackages = [
    pkgsUnstable.godot_4
    pkgsUnstable.godot_4-export-templates-bin
  ];
}
