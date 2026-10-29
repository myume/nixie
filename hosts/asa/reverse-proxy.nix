{
  config,
  lib,
  ...
}: let
  domain = "meyume.com";
  apps = {
    jellyfin = 8096;
    kavita = config.services.kavita.settings.Port;
    brainsoup = config.systemd.services.brainsoup.environment.PORT;
  };
in {
  security.acme = {
    acceptTerms = true;
    defaults.email = "contact@meyume.com";
    certs.${domain} = {
      domain = "*.${domain}";
      dnsProvider = "cloudflare";
      environmentFile = "/etc/acme/cloudflare.env";
      group = config.services.caddy.group;
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts =
      lib.mapAttrs'
      (name: port:
        lib.nameValuePair "${name}.${domain}" {
          extraConfig = ''
            tls /var/lib/acme/${domain}/cert.pem /var/lib/acme/${domain}/key.pem
            reverse_proxy 127.0.0.1:${toString port}
          '';
        })
      apps;
  };
}
