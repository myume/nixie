{
  services.hypridle = let
    lock = "pidof hyprlock || hyprlock";
    display = status: "niri msg action power-${status}-monitors";
  in {
    enable = true;

    settings = {
      general = {
        lock_cmd = lock;
        before_sleep_cmd = lock;
        after_sleep_cmd = display "on";
        ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 5 * 60;
          on-timeout = "loginctl lock-session";
        }

        {
          timeout = 6 * 60;
          on-timeout = display "off";
          on-resume = display "on";
        }

        {
          timeout = 10 * 60;
          on-timeout = "systemctl suspend-then-hibernate";
        }
      ];
    };
  };
}
