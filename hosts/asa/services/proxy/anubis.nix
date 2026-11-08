{
  config,
  lib,
  ...
}: let
  anubisSvcs = lib.filterAttrs (_: s: s.anubis.enable) config.selfhosted.services;
in {
  services.anubis.instances =
    lib.mapAttrs (_: s: {
      settings = {TARGET = "http://127.0.0.1:${toString s.port}";} // s.anubis.settings;
    })
    anubisSvcs;

  users.users.caddy.extraGroups = [config.users.groups.anubis.name];
}
