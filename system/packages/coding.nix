{ config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [

    vscodium
    vscode
    git
    rustup
    gccgo14
    openssl
    pkg-config

  ];
}
