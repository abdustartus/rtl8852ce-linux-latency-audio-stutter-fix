#!/bin/bash

if [ "$EUID" -ne 0 ]; then 
  echo "❌ Please run as root (use: sudo ./install.sh)"
  exit 1
fi

echo "Installing RTL8852CE latency + audio fix..."

# backup
if [ -f /etc/modprobe.d/rtw89.conf ]; then
    cp /etc/modprobe.d/rtw89.conf /etc/modprobe.d/rtw89.conf.bak
fi

cp rtw89.conf /etc/modprobe.d/

update-initramfs -u

echo "Installing CPU performance tools..."
apt install -y linux-tools-common linux-tools-generic

echo "Setting CPU governor to performance..."
cpupower frequency-set -g performance

echo "Done. Reboot required."
