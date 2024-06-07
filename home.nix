{ config, pkgs, lib, ... }:

{

    home.stateVersion = "24.11";

    programs.htop.enable = true;
    programs.htop.settings.show_program_path = true;

    programs = {
        zsh = {
            enable = true;
            oh-my-zsh = {
                enable = true;
                theme = "robbyrussell";
                plugins = [
                    "sudo"
                    "git"
                ];
            };
            
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;
            enableCompletion = true;
        };
    };

    home.packages = with pkgs; [
        coreutils
        curl
        wget
        git
        tmux
    ];
}