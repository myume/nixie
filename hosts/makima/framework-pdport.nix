{pkgs, ...}: {
  # Sometimes pd port doesn't come back after a suspend/hibernate/reboot
  # This is an attempt to revive it after we detect it stopped working
  powerManagement = {
    powerDownCommands = ''
      if [ -e /sys/class/typec/port1-partner ]; then
        touch /run/framework-pd-fix-state
      else
        rm -f /run/framework-pd-fix-state
      fi
    '';

    resumeCommands = ''
      if [ -e /run/framework-pd-fix-state ]; then
        rm -f /run/framework-pd-fix-state
        sleep 5
        if [ ! -e /sys/class/typec/port1-partner ]; then
          ${pkgs.framework-tool}/bin/framework_tool --pd-disable 0
          sleep 3
          ${pkgs.framework-tool}/bin/framework_tool --pd-enable 0
        fi
      fi
    '';
  };
}
