# things shared between all desktop environments
#
#

{ pkgs, ... } : {

  imports = [
    ../apps-gui/zed-editor.nix
  ];

  programs.firefox.enable = true;

  environment.systemPackages = [
    pkgs.sublime-merge
  ];

  # Allows Cosmic's built in app store to get software from flathub
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

}
