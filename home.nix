{ config, pkgs, ... }:

{
  home.username = "blutics";
  home.homeDirectory = "/home/blutics";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    git
    neovim
    htop
    curl
  ];

  programs.bash.enable = true;
  programs.bash.shellAliases = {
    ll = "ls -alh";
    gs = "git status";
  };
}
