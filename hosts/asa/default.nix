{
  pkgs,
  lib,
  inputs,
  ...
}: let
  tunnel_id = "9bab2b63-839a-4cfe-bae3-c82e31b8d4d9";
in {
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
    mpv
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

    cloudflared = {
      enable = true;
      tunnels = {
        "${tunnel_id}" = {
          credentialsFile = "/home/yum/.cloudflared/${tunnel_id}.json";
          default = "http_status:404";
        };
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

  systemd.services."cloudflared-tunnel-${tunnel_id}".serviceConfig = {
    Restart = lib.mkForce "always";
    RestartSec = lib.mkForce "5s";
  };

  system.stateVersion = "25.11";
}
