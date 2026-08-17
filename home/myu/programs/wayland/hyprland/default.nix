{
  lib,
  pkgs,
  config,
  ...
}: let
  quickshell =
    if config.layer-shell.quickshell.enable
    then ["quickshell -d"]
    else [];

  autostart = quickshell;
in {
  imports = lib.filesystem.listFilesRecursive ./settings;

  options.compositor.hyprland = {
    enable = lib.mkEnableOption "Hyprland";
  };

  config = lib.mkIf config.compositor.hyprland.enable {
    home.packages = with pkgs; [
      # hyprshot

      wireplumber
      playerctl
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      xwayland.enable = true;
      settings = {
        exec-once = autostart;
      };
    };
  };
}
