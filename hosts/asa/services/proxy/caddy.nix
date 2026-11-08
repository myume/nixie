{
  config,
  lib,
  ...
}: let
  inherit (config.selfhosted) domain;

  upstream = s:
    if s.anubis.enable
    then "unix//run/anubis/anubis-${s.name}/anubis.sock"
    else "127.0.0.1:${toString s.port}";
in {
  security.acme = {
    acceptTerms = true;
    defaults.email = "contact@meyume.com";
    certs.${domain} = {
      domain = "*.${domain}";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      environmentFile = "/etc/acme/cloudflare.env";
      group = config.services.caddy.group;
    };
  };

  services.caddy = {
    enable = true;
    globalConfig = "metrics";
    virtualHosts =
      lib.mapAttrs'
      (_: attrs:
        lib.nameValuePair attrs.host {
          extraConfig = ''
            tls /var/lib/acme/${domain}/fullchain.pem /var/lib/acme/${domain}/key.pem
            reverse_proxy ${upstream attrs} {
              header_up X-Real-IP {remote_host}
              header_up X-Http-Version {http.request.proto}
            }
          '';
        })
      (lib.filterAttrs (_: s: s.port != null) config.selfhosted.services);
  };
}
