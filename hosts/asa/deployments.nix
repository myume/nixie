let
  hostrunner = "forgejo-runner-guerrilla";
in {
  systemd.user.services.brainsoup = {
    description = "Brainsoup Service";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "/var/lib/brainsoup/brainsoup";
      Restart = "always";
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/myapp-bin 0755 ${hostrunner} ${hostrunner} -"
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
