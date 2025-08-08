#!/bin/bash

# WSL + Arch + Nix 자동 초기화 스크립트
# 시스템 요구사항: WSL2 + Arch 설치 완료 상태
# 실행 위치: root 사용자로 처음 Arch에 진입한 후

set -e

USERNAME="blutics"
USERHOME="/home/$USERNAME"
CONFIG_REPO="https://github.com/blutics/arch-nix-nvim-setup"

log() {
  echo "[INFO] $1"
}

log "1. pacman 업데이트 및 필수 패키지 설치"
pacman -Sy --noconfirm base-devel sudo git curl wget nano

log "2. 사용자 생성 및 sudo 권한 설정"
useradd -m -G wheel -s /bin/bash "$USERNAME"
echo "$USERNAME:changeme" | chpasswd

echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/99-wheel
chmod 440 /etc/sudoers.d/99-wheel

log "3. WSL 기본 로그인 사용자 설정"
echo -e "[user]\ndefault=$USERNAME" > /etc/wsl.conf

log "4. /nix 디렉토리 생성 및 권한 설정"
mkdir -m 0755 /nix
chown "$USERNAME" /nix

log "5. Nix 설치 (--no-daemon 모드로 사용자 환경에 설치)"
su - "$USERNAME" -c "bash <(curl -L https://nixos.org/nix/install) --no-daemon"

log "6. Nix experimental-features 설정"
mkdir -p "$USERHOME/.config/nix"
echo "experimental-features = nix-command flakes" >> "$USERHOME/.config/nix/nix.conf"
chown -R "$USERNAME" "$USERHOME/.config"

log "7. 사용자 설정 저장소 클론"
su - "$USERNAME" -c "git clone $CONFIG_REPO \"$USERHOME/nix-config\""

log "8. Home Manager 설정 적용"
su - "$USERNAME" -c "
  cd \"$USERHOME/nix-config\"
  nix flake lock
  home-manager switch --flake .#blutics
"

log "초기화 완료"
echo "로그인 후 반드시 비밀번호를 변경하세요: passwd"
echo "사용자 홈: $USERHOME"
echo "Home Manager 설정 디렉토리: $USERHOME/nix-config"
echo "Neovim 설정도 동일 리포지토리에 포함됨"
echo "nix run .#homeConfigurations.blutics.activationPackage 로 재적용 가능"
