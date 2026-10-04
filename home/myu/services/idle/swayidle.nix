{pkgs, ...}: {
  services.swayidle = let
    hyprlockBin = "${pkgs.hyprlock}/bin/hyprlock";
    lock = "pidof hyprlock || ${hyprlockBin}";
    display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";
  in {
    enable = false;

    events = {
      inherit lock;
      before-sleep = lock;
      after-resume = display "on";
      unlock = display "on";
    };

    timeouts = [
      {
        timeout = 5 * 60;
        command = lock;
      }
      {
        timeout = 6 * 60;
        command = display "off";
        resumeCommand = display "on";
      }
      {
        timeout = 10 * 60;
        command = "${pkgs.systemd}/bin/systemctl suspend-then-hibernate";
      }
    ];
  };
}
