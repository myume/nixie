{config, ...}: {
  selfhosted.services.qbittorrent = {
    name = "qb";
    port = 9000;
  };

  services.qbittorrent = {
    enable = true;
    webuiPort = config.selfhosted.services.qbittorrent.port;
  };
}
