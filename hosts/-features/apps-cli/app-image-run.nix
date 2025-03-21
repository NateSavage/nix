{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.appimage-run ];
  programs.appimage.binfmt = true;
}
