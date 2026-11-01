{
  config,
  pkgs,
  ...
}: {
  selfhosted.services.jellyfin = {
    port = 8096;
  };

  services.jellyfin.enable = true;

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-compute-runtime-legacy1
      ];
    };
  };

  users.users.${config.services.jellyfin.user}.extraGroups = ["render" "video"];
}
