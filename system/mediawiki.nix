{ config, pkgs, ... }:
  
  # local MediaWiki for Development of PlenumBot:

{
  services.mediawiki = {
    enable = false;
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
      $wgGroupPermissions['*']['edit'] = true;
    '';

    extensions = {
      # some extensions are included and can enabled by passing null
      VisualEditor = null;
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

