{config, ...}: {
  selfhosted.services.filebrowser = {
    name = "fs";
    port = 3001;
  };

  services.filebrowser = {
    enable = true;
    settings = {
      port = config.selfhosted.services.filebrowser.port;
    };
  };
}
