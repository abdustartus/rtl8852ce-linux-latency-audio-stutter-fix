#!/bin/bash

if [ "$EUID" -ne 0 ]; then 
  echo "❌ Please run as root (sudo ./install.sh)"
  exit 1
fi

echo "Installing RTL8852CE latency fix..."

# backup
if [ -f /etc/modprobe.d/rtw89.conf ]; then
    echo "Backing up existing config..."
    cp /etc/modprobe.d/rtw89.conf /etc/modprobe.d/rtw89.conf.bak
fi

# install config
cp rtw89.conf /etc/modprobe.d/

echo "Updating initramfs..."
update-initramfs -u -k all

echo "Reloading driver..."
modprobe -r rtw89_8852ce rtw89_pci rtw89_core 2>/dev/null
modprobe rtw89_8852ce 2>/dev/null

echo ""
echo "✅ RTL8852CE latency fix installed"
echo "🔁 Reboot recommended"
