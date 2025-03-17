{ pkgsUnstable, ... } : {

  #nixpkgs.config.permittedInsecurePackages = [
  #  "dotnet-sdk-6.0.428"
  #];

  environment.systemPackages = [
    pkgsUnstable.godot_4-mono
    pkgsUnstable.godot_4-export-templates
  ];
}
