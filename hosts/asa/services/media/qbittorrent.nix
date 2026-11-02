{
  config,
  lib,
  pkgs,
  ...
}: let
  categories = {
    movies = "${config.selfhosted.mediaDir}/library/movies";
    shows = "${config.selfhosted.mediaDir}/library/shows";
    "light-novels" = "${config.selfhosted.mediaDir}/library/books/light_novels";
  };

  categoriesJson =
    pkgs.writeText "categories.json"
    (builtins.toJSON (
      builtins.mapAttrs (_: save_path: {
        inherit save_path;
      })
      categories
    ));
in {
  selfhosted.services.qbittorrent = {
    name = "qb";
    port = 7476;
  };

  services.qbittorrent = {
    enable = true;
    webuiPort = 8008;
    serverConfig = {
      Preferences = {
        Downloads = {
          TempPath = "${config.selfhosted.mediaDir}/downloads/incomplete";
          TempPathEnabled = true;
        };
        WebUI = {
          Address = "127.0.0.1";
          Username = "admin";
          Password_PBKDF2 = "@ByteArray(/NUNAsLnsbOMZsO9BHB99g==:3kwDyFIAfdg3GsimZ256p6VVPnSnQszP+wy4ikW4bKH6Sy5JyYzmiZnFTppcu7hpw4XSQxJhd7KlUKzYs+FJ7w==)";
        };
      };
    };
  };
  systemd.services.qbittorrent = {
    serviceConfig = {
      UMask = "0002";
      ExecStartPre = lib.mkAfter [
        "${pkgs.coreutils}/bin/install -Dm600 ${categoriesJson} /var/lib/qBittorrent/qBittorrent/config/categories.json"
      ];
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
