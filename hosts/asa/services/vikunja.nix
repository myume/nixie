{config, ...}: {
  selfhosted.services.vikunja = {
    name = "tasks";
    port = 7777;
  };

  services.vikunja = {
    enable = true;
    address = "127.0.0.1";
    port = config.selfhosted.services.vikunja.port;
    frontendScheme = "https";
    frontendHostname = config.selfhosted.services.vikunja.host;
  };
}
