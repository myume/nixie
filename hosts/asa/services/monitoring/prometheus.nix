{config, ...}: {
  selfhosted.services.prometheus = {
    name = "metrics";
    port = 9090;
  };

  services = {
    prometheus = {
      enable = true;
      port = config.selfhosted.services.prometheus.port;
      globalConfig = {
        scrape_interval = "15s";
      };

      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [
            {targets = ["127.0.0.1:${toString config.services.prometheus.exporters.node.port}"];}
          ];
        }
        {
          job_name = "comin";
          static_configs = [{targets = ["127.0.0.1:${toString config.services.comin.exporter.port}"];}];
        }
        {
          job_name = "caddy";
          static_configs = [{targets = ["127.0.0.1:2019"];}];
        }
      ];

      exporters.node = {
        enable = true;
        enabledCollectors = ["systemd"];
        port = 9100;
      };

      alertmanagers = [
        {
          static_configs = [{targets = ["127.0.0.1:9093"];}];
        }
      ];

      rules = [
        (builtins.toJSON {
          groups = [
            {
              name = "asa";
              rules = [
                {
                  alert = "ScrapeTargetDown";
                  expr = ''up == 0'';
                  "for" = "2m";
                  annotations.summary = "{{ $labels.job }} is not being scraped";
                }
                {
                  alert = "UnitFailed";
                  expr = ''node_systemd_unit_state{state="failed"} == 1'';
                  "for" = "5m";
                  annotations.summary = "{{ $labels.name }} is in failed state";
                }
                {
                  alert = "DiskFillingSoon";
                  expr = ''predict_linear(node_filesystem_avail_bytes{fstype!~"tmpfs|ramfs"}[6h], 4*24*3600) < 0'';
                  "for" = "1d";
                  annotations.summary = "{{ $labels.mountpoint }} predicted full within 4 days";
                }
                {
                  alert = "DiskAlmostFull";
                  expr = ''node_filesystem_avail_bytes{fstype!~"tmpfs|ramfs"} / node_filesystem_size_bytes < 0.10'';
                  "for" = "10m";
                  annotations.summary = "{{ $labels.mountpoint }} under 10% free";
                }
                {
                  alert = "HighMemory";
                  expr = ''node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes < 0.10'';
                  "for" = "10m";
                  annotations.summary = "Under 10% memory available";
                }
                {
                  alert = "NixDeploymentFailed";
                  expr = ''comin_last_eval_failed == 1 or comin_last_build_failed == 1 or comin_last_deployment_failed == 1'';
                  "for" = "30m";
                  labels = {
                    severity = "critical";
                  };
                  annotations = {
                    summary = "Comin GitOps build or evaluation failed on {{ $labels.instance }}";
                    description = "The latest commit failed to evaluate or switch successfully.";
                  };
                }
              ];
            }
          ];
        })
      ];

      alertmanager = {
        enable = true;
        listenAddress = "127.0.0.1";
        port = 9093;
        configuration = {
          route = {
            receiver = "ntfy";
            group_by = ["alertname"];
            group_wait = "30s";
            repeat_interval = "12h";
          };
          receivers = [
            {
              name = "ntfy";
              webhook_configs = [
                {
                  url = "http://${config.services.ntfy-sh.settings.listen-http}/asa?template=alertmanager";
                  send_resolved = true;
                }
              ];
            }
          ];
        };
      };
    };
  };
}
