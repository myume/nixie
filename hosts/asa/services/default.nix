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
      anubis = {
        enable = lib.mkEnableOption "Anubis in front of this service";

        settings = lib.mkOption {
          type = with lib.types; attrsOf (oneOf [str int bool]);
          default = {};
          example = {DIFFICULTY = 6;};
          description = "Extra Anubis environment settings for this instance, merged over the defaults.";
        };
      };
    };
  };
in {
  imports = [
    ./brainsoup.nix
    ./filebrowser.nix
    ./forgejo.nix
    ./vaultwarden.nix
    ./vikunja.nix
    ./media
    ./monitoring
    ./proxy
  ];

  options.selfhosted = {
    domain = mkOption {type = types.str;};
    services = mkOption {
      type = types.attrsOf (types.submodule serviceDecl);
      default = {};
    };
    mediaDir = lib.mkOption {
      type = types.str;
      default = "/srv/media";
    };
  };
}
