{
  config,
  lib,
  ...
}: {
  selfhosted.services.gatus = {
    name = "uptime";
    port = 8888;
  };

  services.gatus = {
    enable = true;
    settings = {
      web.port = config.selfhosted.services.gatus.port;

      alerting.ntfy = {
        url = config.services.ntfy-sh.settings.listen-http;
        topic = "asa";
        priority = 4;
        default-alert = {
          failure-threshold = 3;
          success-threshold = 2;
          send-on-resolved = true;
        };
      };

      endpoints = lib.mapAttrsToList (name: s: {
        inherit name;
        url = "https://${s.host}";
        interval = "1m";
        conditions = ["[STATUS] < 400"];
        alerts = [{type = "ntfy";}];
      }) (lib.filterAttrs (_: s: s.port != null) config.selfhosted.services);
    };
  };
}
