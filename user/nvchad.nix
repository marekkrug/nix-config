{ inputs, config, pkgs, ... }: {
  imports = [
    inputs.nvchad4nix.homeManagerModule
  ];
  programs.nvchad = {
    enable = true;
    extraPackages = with pkgs; [
      nodePackages.bash-language-server
      docker-compose-language-service
      dockerfile-language-server-nodejs
      emmet-language-server
      nixd
      (python3.withPackages(ps: with ps; [
        python-lsp-server
        flake8
      ]))
    ];
    extraConfig = pkgs.fetchFromGitHub {  # <- you can set your repo here
      owner = "NvChad";
      repo = "starter";
      rev = "41c5b467339d34460c921a1764c4da5a07cdddf7";
      sha256 = "sha256-yxZTxFnw5oV/76g+qkKs7UIwgkpD+LkN/6IJxiV9iRY=";
      name = "nvchad-2.5-starter";
    };
    hm-activation = true;
    backup = true;
  };
}