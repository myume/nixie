{
  config,
  lib,
  ...
}: let
  inherit (config.selfhosted) domain;
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
    virtualHosts =
      lib.mapAttrs'
      (_: attrs:
        lib.nameValuePair attrs.host {
          extraConfig = ''
            tls /var/lib/acme/${domain}/fullchain.pem /var/lib/acme/${domain}/key.pem
            reverse_proxy 127.0.0.1:${toString attrs.port}
          '';
        })
      (lib.filterAttrs (_: s: s.port != null) config.selfhosted.services);
  };
}
