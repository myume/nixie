{config, ...}: {
  selfhosted.services.kavita = {
    port = 5000;
  };

  services.kavita = {
    enable = true;
    tokenKeyFile = "/var/lib/kavita/token_key";
    settings = {
      Port = config.selfhosted.services.kavita.port;
    };
  };
}
