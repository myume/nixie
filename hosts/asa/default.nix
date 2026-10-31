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
    ./services
    inputs.comin.nixosModules.comin
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-compute-runtime-legacy1
      ];
    };
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users = {
    yum = {
      isNormalUser = true;
      description = "yum";
      extraGroups = ["networkmanager" "wheel" "render" "video"];
      homeMode = "710";
    };

    kavita.extraGroups = ["users"];
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  environment.systemPackages = with pkgs; [
    vim
    git
    btop
  ];

  virtualisation.podman.enable = true;

  selfhosted.domain = "meyume.com";
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
  };

  system.stateVersion = "25.11";
}
