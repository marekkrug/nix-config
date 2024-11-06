_:
{
  services.nginx = {
    enable = true;

    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;

    virtualHosts = {
      "miracunix" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000/";
          proxyWebsockets = true;
        };

        serverAliases = [ "172.23.43.188" ];
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      8001
      3000
    ];
    allowedUDPPorts = [ 2342 ];
  };
}
