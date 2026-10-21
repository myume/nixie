{
  nixpkgs,
  home-manager,
  ciri,
  ...
} @ inputs: {
  makima = let
    hostname = "makima";
  in
    nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit hostname;
        inherit inputs;
      };

      modules = [
        (./. + "/${hostname}")

        ciri.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            extraSpecialArgs = {inherit inputs;};
            users = {
              myu = import ../home/myu/home.nix;
            };
          };
        }
      ];
    };

  # thinkpad
  asa = let
    hostname = "asa";
  in
    nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit hostname;
        inherit inputs;
      };

      modules = [
        (./. + "/${hostname}")
      ];
    };
}
