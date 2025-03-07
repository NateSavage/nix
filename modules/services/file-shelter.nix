

{ pkgs, ... }: {

  systemd.user.services.file-shelter = {
    enable = true;
    path = [ pkgs.file-shelter ];

    after = [ "network.target" ];
    wantedBy = [ "default.target" ];
    description = "A 'one-click' file sharing web application";
    serviceConfig = {
        Type = "simple";
        ExecStart = '${nix-shelter}/bin/;
    };
  };

}
