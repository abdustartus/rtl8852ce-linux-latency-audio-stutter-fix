#!/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then 
  echo "❌ Please run as root (use: sudo ./install.sh)"
  exit 1
fi

echo "Installing RTL8852CE latency fix..."

# Backup existing config if it exists
if [ -f /etc/modprobe.d/rtw89.conf ]; then
    echo "Creating backup of existing rtw89.conf..."
    cp /etc/modprobe.d/rtw89.conf /etc/modprobe.d/rtw89.conf.bak
fi

# Copy the new fix
cp rtw89.conf /etc/modprobe.d/

# Update initramfs
update-initramfs -u

echo "✅ Fix applied. Please reboot your system."
