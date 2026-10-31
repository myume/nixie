{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/networking
    ../../modules/networking/tailscale.nix
    ../../modules/locale
    inputs.comin.nixosModules.comin
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users = {
    yum = {
      isNormalUser = true;
      description = "yum";
      extraGroups = ["networkmanager" "wheel"];
      packages = with pkgs; [];
      homeMode = "710";
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  services = {
    openssh.enable = true;

    getty = {
      autologinUser = "yum";
    };

    logind = {
      settings.Login = {
        HandleLidSwitch = "ignore";
        HandleLidSwitchDocked = "ignore";
        HandleLidSwitchExternalPower = "ignore";
        IdleAction = "ignore";
        HandlePowerKey = "ignore";
        HandleSuspendKey = "ignore";
      };
    };

    comin = {
      enable = true;
      remotes = [
        {
          name = "origin";
          url = "https://github.com/myume/nixie";
          branches.main.name = "main";
        }
      ];
    };
  };

  system.stateVersion = "26.05";
}
