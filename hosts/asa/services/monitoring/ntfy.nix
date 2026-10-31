{config, ...}: {
  selfhosted.services.ntfy.port = 2586;
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://${config.selfhosted.services.ntfy.host}";
      listen-http = "127.0.0.1:${toString config.selfhosted.services.ntfy.port}";
    };
  };
}
