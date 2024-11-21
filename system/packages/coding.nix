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
    jetbrains-toolbox
    jetbrains.rust-rover
    jetbrains.goland
    jetbrains.pycharm-community
    sqlite
    xz
    ghc
    gnumake
    dotnet-sdk_8
  ];
}
