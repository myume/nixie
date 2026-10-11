{
  systemd.services.brainsoup = {
    description = "Brainsoup Service";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "/var/lib/brainsoup/brainsoup";
      Restart = "always";
    };
  };
}
