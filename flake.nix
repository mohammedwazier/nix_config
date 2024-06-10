{
  description = "Masihkasar Minimal Nix Config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    unstable.url = "nixpkgs/nixos-unstable";	    
    devenv.url = "github:cachix/devenv/latest";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "unstable";
    };
  };
	
  outputs = { self, nixpkgs, unstable, devenv, fenix, ... }: {
    packages."aarch64-darwin".default = let
      pkgs = nixpkgs.legacyPackages."aarch64-darwin";
      unstablePkgs = unstable.legacyPackages."aarch64-darwin";

      php-vips = pkgs.php81.buildPecl {
        pname = "vips";
        version = "1.0.3";
        sha256 = "TmVYQ+XugVDJJ8EIU9+g0qO5JLwkU+2PteWiqQ5ob48=";
        buildInputs = [ pkgs.vips pkgs.pkg-config ];
      };
      php81 = pkgs.php81.buildEnv {
        extensions = ({
          enable, all
        }: enable ++ (with all; [
          xdebug
          opcache
          redis
          php-vips
        ]));
        extraConfig = "memory_limit = 2G";
      };
    in pkgs.buildEnv {
      name = "home-packages";
      paths = with pkgs; [

        # general tools
        git
        ffmpeg
        curl
        wget
        jq
        ripgrep
        tmux

        # ... add your tools here
        devenv.packages.aarch64-darwin.devenv
        mitmproxy
        cfssl
        dive
        graphvizz
        dive
        lnav
        watchman
        vecto
        inetutils

        #programming environments
        php81
        symfony-cli
        yarn
        deno
        bun
        fenix.packages."aarch64-darwin".minimal.toolchains # rust
      ];
    };
  };
	
	}