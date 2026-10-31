{
  lib,
  config,
  ...
}: let
  inherit (lib) types mkOption;
  top = config;

  serviceDecl = {
    name,
    config,
    ...
  }: {
    options = {
      name = mkOption {
        type = types.str;
        default = name;
      };
      port = mkOption {
        type = types.nullOr types.port;
        default = null;
      };
      host = mkOption {
        type = types.str;
        default = "${config.name}.${top.selfhosted.domain}";
      };
    };
  };
in {
  imports = [
    ./brainsoup.nix
    ./caddy.nix
    ./filebrowser.nix
    ./forgejo.nix
    ./jellyfin.nix
    ./kavita.nix
    ./monitoring
  ];

  options.selfhosted = {
    domain = mkOption {type = types.str;};
    services = mkOption {
      type = types.attrsOf (types.submodule serviceDecl);
      default = {};
    };
  };
}
