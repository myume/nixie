{
  config,
  lib,
  ...
}: let
  mediaDir = "/srv/media";
  mediaServices = ["qbittorrent" "jellyfin" "kavita"];
  mediaUsers =
    ["yum"]
    ++ map (service: config.services.${service}.user) mediaServices;

  dirs = [
    ""
    "downloads"
    "downloads/incomplete"
    "library"
    "library/movies"
    "library/shows"
    "library/music"
    "library/books"
    "library/audiobooks"
  ];
in {
  imports = [
    ./jellyfin.nix
    ./qbittorrent.nix
    ./kavita.nix
  ];

  users = {
    groups.media = {};
    users = lib.genAttrs mediaUsers (_: {extraGroups = ["media"];});
  };

  systemd = {
    tmpfiles.settings."10-media" =
      lib.genAttrs
      (map (rel: lib.removeSuffix "/" "${mediaDir}/${rel}") dirs)
      (_: {
        d = {
          user = "root";
          group = "media";
          mode = "2775";
        };
      });

    services = lib.genAttrs mediaServices (_: {
      unitConfig.RequiresMountsFor = mediaDir;
    });
  };
}
