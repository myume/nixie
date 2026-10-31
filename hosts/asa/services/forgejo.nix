{
  pkgs,
  config,
  ...
}: {
  selfhosted.services = {
    forgejo = {
      port = 3000;
    };
  };

  services = {
    forgejo = {
      enable = true;
      database.type = "postgres";
      lfs.enable = true;
      settings = {
        server = {
          DOMAIN = "git.meyume.com";
          ROOT_URL = "https://git.meyume.com/";
          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = config.selfhosted.services.forgejo.port;

          SSH_DOMAIN = "ssh.meyume.com";
          START_SSH_SERVER = false;
          SSH_PORT = 22;
          SSH_CREATE_AUTHORIZED_KEYS_FILE = true;
        };
        service.DISABLE_REGISTRATION = true;
        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "github";
        };
      };
    };

    forgejo-runner = {
      package = pkgs.forgejo-runner;
      instances = {
        revy = {
          enable = true;
          runtimes.host = true;
          settings = {
            runner.labels = [
              "nix:docker://nixos/nix:2.34.8"
              "ubuntu-latest:docker://ubuntu:latest"
            ];
            server.connections.forgejo = {
              url = "http://127.0.0.1:3000";
              uuid = "6fe63732-1a64-4e41-97d8-fe10f8ce6b44";
            };
          };
          secrets.server.connections."forgejo".token_url = "/var/lib/forgejo/revy_token";
        };
        guerrilla = {
          enable = true;
          runtimes.host = true;
          hostPackages = with pkgs; [
            bash
            coreutils
            curl
            gawk
            gnugrep
            gnused
            nodejs
            wget
            gitMinimal
            nix
          ];
          settings = {
            runner.labels = [
              "native:host"
            ];
            server.connections.forgejo = {
              url = "http://127.0.0.1:3000";
              uuid = "b050c348-e6e7-4c1e-afae-cbe9ab296ac7";
            };
          };
          secrets.server.connections."forgejo".token_url = "/var/lib/forgejo/native_token";
        };
      };
    };
  };
}
