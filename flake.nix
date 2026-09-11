{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    waysted.url = "github:myume/waysted";
    wally.url = "github:myume/wally";

    fsel.url = "github:Mjoyufull/fsel";

    ciri.url = "github:myume/ciri";
  };

  outputs = inputs: {
    nixosConfigurations = import ./hosts inputs;
  };
}
