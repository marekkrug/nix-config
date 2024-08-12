{ config, pkgs, ... }:
  
  # local MediaWiki for Development of PlenumBot:

{
  services.mediawiki = {
    enable = true;
    # Prior to NixOS 24.05, there is a admin name bug that prevents using spaces in the mediawiki name https://github.com/NixOS/nixpkgs/issues/298902
    name = "Test_MediaWiki";
    httpd.virtualHost = {
      hostName = "localhost";
      adminAddr = "mail@marekkrug.de";
    };
    # Administrator account username is admin.
    # Set initial password to "cardbotnine" for the account admin.
    passwordFile = pkgs.writeText "password" "cardbotnine";
    extraConfig = ''
      # Disable anonymous editing
      $wgGroupPermissions['*']['edit'] = false;
    '';

    extensions = {
      # some extensions are included and can enabled by passing null
      VisualEditor = null;

      # https://www.mediawiki.org/wiki/Extension:TemplateStyles
      TemplateStyles = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/TemplateStyles-REL1_42-a28054b.tar.gz";
        hash = "sha256-a/kWH9+P7ZujXFUEJ71upesVDGyg6MYcLuaua95DZj8==";
      };
    };
};

services.mediawiki.httpd.virtualHost.listen = [
    {
      ip = "localhost";
      port = 80;
      ssl = false;
    }
  ];
}