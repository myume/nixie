{config, ...}: {
  selfhosted.services.grafana.port = 3002;

  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = config.selfhosted.services.grafana.port;
        domain = config.selfhosted.services.grafana.host;
      };
      security.secret_key = "$__file{/var/lib/secrets/grafana-secret-key}";
    };
    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://localhost:${toString config.selfhosted.services.prometheus.port}";
          isDefault = true;
        }
      ];
    };
  };
}
