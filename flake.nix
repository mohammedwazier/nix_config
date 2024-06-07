{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, ...}:
  let
    configuration = { pkgs, ... }: {
      users.users.masihkasar.home = "/var/empty";
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
          pkgs.vim
          pkgs.discord
          pkgs.terminal-notifier
          pkgs.home-manager
          pkgs.oh-my-zsh
          pkgs.screenfetch
          # pkgs.postman
          # pkgs.zed-editor
          # pkgs.dbeaver-bin
        ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      # programs.zsh.enable = true;  # default shell on catalina
      programs.zsh = {
        enable = true;
        enableCompletion = true;
      };
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      fonts.fontDir.enable = true;
      fonts.fonts = with pkgs; [
        recursive
        (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      ];

      # The platform the configuration will be used on.
      # nixpkgs.hostPlatform = "aarch64-darwin";
      nixpkgs.hostPlatform = "x86_64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."masihkasars-MacBook-Air" = nix-darwin.lib.darwinSystem {
      modules = [ 
        { nix.extraOptions = ''extra-platforms = x86_64-darwin aarch64-darwin ''; }
        configuration
        home-manager.darwinModules.home-manager 
        {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.config.allowUnsupportedSystem = true;
          nixpkgs.config.allowBroken = true; 

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.masihkasar = import ./home.nix;
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."masihkasars-MacBook-Air".pkgs;
  };
}
