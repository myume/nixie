{config, ...}: {
  selfhosted.services.qbittorrent = {
    name = "qb";
    port = 7476;
  };

  services.qbittorrent = {
    enable = true;
    webuiPort = 8008;
    serverConfig = {
      Preferences.WebUI = {
        Address = "127.0.0.1";
        Username = "admin";
        Password_PBKDF2 = "@ByteArray(/NUNAsLnsbOMZsO9BHB99g==:3kwDyFIAfdg3GsimZ256p6VVPnSnQszP+wy4ikW4bKH6Sy5JyYzmiZnFTppcu7hpw4XSQxJhd7KlUKzYs+FJ7w==)";
      };
    };
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
