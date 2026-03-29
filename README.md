# RTL8852CE Linux WiFi Latency + Audio Stutter Fix

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This repository provides a **complete fix** for **Realtek RTL8852CE (rtw89)** latency issues and **random audio stalls** on Linux.

Fixes:

* 1000ms ping spikes
* packet loss
* YouTube audio stutter
* random audio stalls after boot
* WiFi instability on 5 GHz
* PipeWire audio glitches
* CPU powersave audio freezes

---

# Tested Hardware

* Gigabyte Z790 D AX
* Realtek RTL8852CE
* Intel 12th / 13th / 14th Gen CPU
* Linux kernel 6.x
* PipeWire audio
* WiFi 6 router (802.11ax)

---

# Installation

## Option 1 — Automatic Install (Recommended)

```
chmod +x install.sh
sudo ./install.sh
sudo reboot
```

---

## Option 2 — Manual Install

```
sudo cp rtw89.conf /etc/modprobe.d/
sudo update-initramfs -u
sudo reboot
```

Then apply CPU fix:

```
sudo apt install linux-tools-common linux-tools-generic -y
sudo cpupower frequency-set -g performance
```

---

# Symptoms

You may be affected if you experience:

* 500ms–1000ms ping spikes
* random packet loss
* YouTube audio stuttering
* audio stalls after boot
* WiFi signal strong but unstable
* SSH lag over LAN
* gaming jitter

Example:

```
64 bytes time=1.2 ms
64 bytes time=1.4 ms
64 bytes time=1050 ms
64 bytes time=900 ms
```

---

# Step 1 — Diagnose WiFi Latency

Check latency to router:

```
ping 192.168.1.1
```

If spikes above 100 ms appear, continue.

---

# Step 2 — Check Connected Band

```
iw dev
```

Example:

```
channel 40 (5200 MHz)
```

5200 MHz = 5 GHz

---

# Step 3 — Test 2.4 GHz vs 5 GHz

Connect to **2.4 GHz**:

```
ping 192.168.1.1 (default gateway)
```

Then connect to **5 GHz**:

```
ping 192.168.1.1 (default gateway)
```

If:

* 2.4 GHz stable
* 5 GHz unstable

Router WiFi 6 / bandwidth issue confirmed.

---

# Step 4 — Router Configuration Fix

## 2.4 GHz

Use:

```
802.11b+g+n
```

Avoid:

```
802.11ax
```

---

## 5 GHz

Use:

```
802.11ac
```

Avoid:

```
802.11ax
160 MHz
```

Recommended:

```
Bandwidth: 80 MHz or 40 MHz (Recommended)
```

---

# Step 5 — Disable NetworkManager WiFi Powersave

Check:

```
/etc/NetworkManager/conf.d/wifi-powersave.conf
```

If present remove:

```
[connection]
wifi.powersave = 2
```

Restart NetworkManager:

```
sudo systemctl restart NetworkManager
```

---

# Step 6 — Apply rtw89 Fix

Create:

```
sudo nano /etc/modprobe.d/rtw89.conf
```

Add:

```
options rtw89_pci disable_clkreq=y
options rtw89_pci disable_aspm_l1=y
options rtw89_pci disable_aspm_l1ss=y
options rtw89_core disable_ps_mode=y
```

Apply:

```
sudo update-initramfs -u
sudo reboot
```

---

# Step 7 — Fix Random Audio Stalls (IMPORTANT)

Check CPU governor:

```
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```

If you see:

```
powersave
```

Switch to performance:

```
sudo apt install linux-tools-common linux-tools-generic -y
sudo cpupower frequency-set -g performance
```

---

# Make CPU Fix Permanent

Create service:

```
sudo nano /etc/systemd/system/cpu-performance.service
```

Paste:

```
[Unit]
Description=Set CPU governor to performance
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c "sleep 5 && /usr/bin/cpupower frequency-set -g performance"

[Install]
WantedBy=multi-user.target
```

Enable:

```
sudo systemctl daemon-reload
sudo systemctl enable cpu-performance.service
sudo reboot
```

---

# Verification

WiFi:

```
ping 192.168.1.1 (default gateway)
```

Expected:

```
1.1 ms
1.3 ms
1.5 ms
1.6 ms
```

Audio:

* no YouTube stalls
* no random freezes
* smooth playback

---

# Before vs After

## Before

* 1000 ms spikes
* packet loss
* YouTube audio stutter
* random audio stalls

## After

* 1–2 ms stable
* 0% packet loss
* smooth audio
* no stalls

---

# Debug Commands

Check driver:

```
lsmod | grep rtw89
```

Check interface:

```
iw dev
```

Check CPU governor:

```
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```

Reload driver:

```
sudo modprobe -r rtw89_8852ce rtw89_pci rtw89_core
sudo modprobe rtw89_8852ce
```

---

# Root Cause

This is caused by combination of:

* rtw89 latency bug
* PCIe ASPM transitions
* WiFi 6 aggregation stalls
* CPU powersave latency
* PipeWire scheduling delay
* firmware power saving conflicts

---

# Files Included

rtw89.conf
install.sh
README.md

---

# Tags

rtl8852ce
rtw89
realtek
realtek-driver
realtek-firmware
linux-wifi
wifi-lag
wifi-stutter
packet-loss
pipewire
audio-stutter
cpu-governor
intel-pstate

---

# If This Helped

Please ⭐ the repository.

This issue is common but poorly documented.
