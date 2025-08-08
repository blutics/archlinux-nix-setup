root로 arch linux에 접근

cd ~
pacman -Sy git
git clone https://github.com/blutics/archlinux-nix-setup.git

cd archlinux-nix-setup
chmod +x install.sh
./install.sh
