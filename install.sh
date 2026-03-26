#!/bin/bash

echo "Installing RTL8852CE latency fix..."

sudo cp rtw89.conf /etc/modprobe.d/

sudo update-initramfs -u

echo "Done. Reboot required."
