{config, ...}: {
  selfhosted.services.qbittorrent = {
    name = "qb";
    port = 7476;
  };

  services.qbittorrent = {
    enable = true;
    webuiPort = 8008;
  };

  services.qui = {
    enable = true;
    secretFile = "/var/lib/secrets/qui-secret";
    settings = {
      port = config.selfhosted.services.qbittorrent.port;

      # metricsEnabled = true;
      # metricsHost = "127.0.0.1";
      # metricsPort = 9074;
    };
  };
}
