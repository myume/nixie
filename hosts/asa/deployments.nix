let
  hostrunner = "forgejo-runner-guerrilla";
in {
  systemd.user.services.brainsoup = {
    description = "Brainsoup Service";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig = {
      ExecStart = "/var/lib/brainsoup/current/bin/bs";
      StateDirectory = "brainsoup";
      WorkingDirectory = "/var/lib/brainsoup";
      Restart = "on-failure";
      RestartSec = 2;
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/brainsoup/current 0755 ${hostrunner} ${hostrunner} -"
  ];

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.systemd1.manage-units" &&
          action.lookup("unit") == "brainsoup.service" &&
          subject.user == "${hostrunner}") {
        return polkit.Result.YES;
      }
    });
  '';
}
