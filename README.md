# RTL8852CE Linux WiFi Latency + Audio Stutter Fix

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This repository provides a permanent solution for **Realtek RTL8852CE (rtw89)** latency issues on Linux. If you are experiencing **1000ms ping spikes**, **packet loss**, or **YouTube audio stuttering** on Ubuntu, Fedora, or Arch Linux, follow these steps.

### 🎯 What this fixes:
* **WiFi Latency Spikes:** Drops 1000ms+ pings down to 1-2ms.
* **Audio Stalling:** Fixes stuttering caused by NetworkManager power saving.
* **PCIe ASPM Conflicts:** Resolves driver-level hardware stalls on Z690/Z790 boards.

---

Tested on:
- Gigabyte Z790 D AX
- Realtek RTL8852CE
- Linux kernel 6.x
- WiFi 6 (802.11ax) router

---

# Installation

You can apply this fix automatically using the included script, or manually.

### Option 1: Automatic Install (Recommended)
Make the script executable and run it with root privileges:
```bash
chmod +x install.sh
sudo ./install.sh

```
### Option 2: Manual Install
If you prefer to apply the fix manually:
```
sudo cp rtw89.conf /etc/modprobe.d/
sudo update-initramfs -u
sudo reboot
```

---

# Symptoms

You may be affected if you see:

- 500ms–1000ms ping spikes
- Random packet loss
- YouTube audio stuttering
- WiFi signal strong but unstable
- SSH lag over LAN
- Gaming jitter

Example:

```
64 bytes time=1.2 ms
64 bytes time=1.4 ms
64 bytes time=1050 ms
64 bytes time=900 ms
```

---

# Affected Hardware

Likely affects:

- RTL8852CE
- RTL8852AE
- RTL8851BE
- rtw89 driver
- WiFi 6 routers
- Intel Z690 / Z790 boards

---

# Step 1 — Diagnose Your WiFi Connection

Check latency to router:

```
ping 192.168.1.1 (use default gateway)
```

If you see spikes above 100 ms, continue.

---

Check connected band:

```
iw dev
```

Example output:

```
channel 40 (5200 MHz)
```

5200 MHz = 5 GHz

---

# Step 2 — Test 2.4 GHz vs 5 GHz

Connect to **2.4 GHz** and test:

```
ping 192.168.1.1 (use default gateway)
```

Then connect to **5 GHz** and test again.

If:

- 2.4 GHz stable
- 5 GHz unstable

Then router WiFi 6 / bandwidth issue confirmed.

---

# Step 3 — Router Configuration Fix

Login to router admin panel.

Check:

## 2.4 GHz

Use one of:

- 802.11b+g+n
- 802.11n

Avoid:

- 802.11ax

---

## 5 GHz Settings (Important)

Change:

Mode:

```
802.11ac or 802.11n/ac
```

Avoid:

```
802.11ax
```

Bandwidth:

```
80 MHz or 40 MHz (Recommended)
```

Avoid:

```
160 MHz
```

---

# Step 4 — Disable NetworkManager WiFi Powersave

Check if file exists:

```
/etc/NetworkManager/conf.d/wifi-powersave.conf
```

If present remove or comment:

```
[connection]
wifi.powersave = 2
```

This can cause **audio stalls**.

---

# Manual Configuration Details

Create config:

```
sudo nano /etc/modprobe.d/rtw89.conf
```

Add:

```
options rtw89_pci disable_clkreq=y
options rtw89_pci disable_aspm_l1=y
options rtw89_pci disable_aspm_l1ss=y
```

Apply:

```
sudo update-initramfs -u
sudo reboot
```

---

# Verification

Run:

```
ping 192.168.1.1 (use default gateway)
```

Expected:

```
1.1 ms
1.3 ms
1.5 ms
1.6 ms
```

No spikes.

---

# Before vs After

## Before

- 1000 ms spikes
- packet loss
- YouTube audio stutter

## After

- 1–2 ms stable
- 0% packet loss
- smooth audio

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

Check powersave:

```
iw dev wlp3s0 get power_save
```

Reload driver:

```
sudo modprobe -r rtw89_8852ce rtw89_pci rtw89_core
sudo modprobe rtw89_8852ce
```

---

# What NOT To Use

Avoid these options (causes instability):

```
disable_ps_mode
disable_tx_agg
disable_rx_agg
disable_btc
```

Only use PCIe ASPM fixes.

---

# Root Cause

This is caused by combination of:

- rtw89 latency bug
- PCIe ASPM transitions
- WiFi 6 aggregation stalls
- 160 MHz DFS pauses
- firmware power saving conflicts

---

# Files Included

rtw89.conf
install.sh
README.md

---

# Quick Tip

Check default gateway

```
ip route | grep default
```
---

# If This Helped

Please ⭐ the repository.

This issue is common but poorly documented.

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
80211ax  
wifi-6

---

