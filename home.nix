{ config, pkgs, ... }:

{
  home.username = "blutics";
  home.homeDirectory = "/home/blutics";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    git
    neovim
    curl
    htop
  ];

  home.stateVersion = "24.05";
}
