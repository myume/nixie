{config, ...}: {
  selfhosted.services.qbittorrent = {
    name = "qb";
    port = 9000;
  };

  services.qbittorrent = {
    enable = true;
  };

  services.qui = {
    enable = true;
    settings = {
      port = config.selfhosted.services.qbittorrent.port;

      metricsEnabled = true;
      metricsHost = "127.0.0.1";
      metricsPort = 9074;
    };
  };
}
