{config, ...}: {
  selfhosted.services.kavita = {
    port = 5000;
  };

  services.kavita = {
    enable = true;
    credentials.token_key = "/var/lib/secrets/kavita-token-file";
    settings = {
      Port = config.selfhosted.services.kavita.port;
    };
  };
}
