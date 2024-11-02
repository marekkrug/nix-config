{ config, pkgs, ... }:
  
  # local MediaWiki for Development of PlenumBot:

{
  services.mediawiki = {
    enable = false;
    # Pr3000ior to NixOS 24.05, there is a admin name bug that prevents using spaces in the mediawiki name https://github.com/NixOS/nixpkgs/issues/298902
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
      #TemplateStyles = pkgs.fetchzip {
      #  url = "https://extdist.wmflabs.org/dist/extensions/TemplateStyles-REL1_35-8dba6c0.tar.gz";
      #  hash = "sha256-Pnp6MXqZd6zjhzNC2qYX6sP33ai5n05+1ucXEbw3XEE=";
      #};
    };
};

services.mediawiki.httpd.virtualHost.listen = [
    {
      ip = "localhost";
      port = 80;
      ssl = false;
    }
  ];

# services.mediawiki.poolConfig = [
#   {
#     pm = "dynamic";
#     "pm.max_children" = 8;
#     "pm.max_requests" = 500;
#     "pm.max_spare_servers" = 4;
#     "pm.min_spare_servers" = 1;
#     "pm.start_servers" = 2;
#   }
# ];
}

