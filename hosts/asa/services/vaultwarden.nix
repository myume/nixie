{config, ...}: {
  selfhosted.services.vaultwarden = {
    name = "vault";
    port = 8686;
  };

  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
    backupDir = "/var/backup/vaultwarden";

    config = {
      DOMAIN = "https://${config.selfhosted.services.vaultwarden.host}";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = config.selfhosted.services.vaultwarden.port;
      SIGNUPS_ALLOWED = false;
    };
  };
}
