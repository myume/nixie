{lib, ...}: let
  tunnel_id = "9bab2b63-839a-4cfe-bae3-c82e31b8d4d9";
in {
  services.cloudflared = {
    enable = true;
    tunnels = {
      "${tunnel_id}" = {
        credentialsFile = "/home/yum/.cloudflared/${tunnel_id}.json";
        default = "http_status:404";
      };
    };
  };

  systemd.services."cloudflared-tunnel-${tunnel_id}".serviceConfig = {
    Restart = lib.mkForce "always";
    RestartSec = lib.mkForce "5s";
  };
}
