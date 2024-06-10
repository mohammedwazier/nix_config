{ pkgs, ... }

{
    languages.php.enable = true;
    laugages.php.package = pkgs.php82;

    # services.mysql

    starship.enable = true;
}