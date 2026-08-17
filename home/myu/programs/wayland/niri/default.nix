{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  quickshell =
    if config.layer-shell.quickshell.enable
    then [
      {
        command = [
          "quickshell"
          "-d"
        ];
      }
    ]
    else [];

  autostart =
    quickshell
    ++ [
      {
        command = [
          "awww-daemon"
          "-n"
          "overview"
        ];
      }
    ];
in {
  imports = [
    ./settings
    inputs.ciri.homeManagerModules.default
  ];

  options.compositor.niri = {
    enable = lib.mkEnableOption "Niri";
  };

  config = lib.mkIf config.compositor.niri.enable {
    home.packages = [
      pkgs.xwayland-satellite
      pkgs.playerctl
    ];

    programs.niri = {
      settings.spawn-at-startup = autostart;
      enable = true;
    };
  };
}
