# RTL8852CE Linux WiFi Latency + Audio Stutter Fix

A **stable latency fix** for Realtek **RTL8852CE / rtw89** on Linux.

This solution removes:
- WiFi latency spikes
- packet loss
- audio/video stutter

without forcing CPU performance mode or disabling WiFi 6.

The fix targets **Realtek driver power-state instability** and **firmware calibration stalls** seen on kernel 6.x.

---

# Symptoms

This fix applies if you experience:

- 500–10000 ms ping spikes
- "Destination Host Unreachable" randomly
- Audio stutter during video playback
- SSH freezing briefly
- Gaming jitter
- Smooth signal but unstable latency
- `[RX_DCK] timeout` in dmesg

---

# Root Cause

The issue is caused by a combination of:

- rtw89 driver power saving
- PCIe ASPM transitions
- Realtek firmware RX calibration stalls
- WiFi 6 timing sensitivity

These create **periodic firmware stalls**, causing latency spikes and audio glitches.

---

# What This Fix Does

This configuration disables unstable Realtek power states:

- WiFi power saving
- PCIe ASPM L1
- PCIe L1 substates
- PCIe clock request transitions

This stabilizes firmware calibration and removes latency spikes.

---

# Balanced vs Aggressive Mode

## Balanced (default recommended)

Keeps:
- WiFi 6 support
- normal power usage
- stable latency

## Aggressive (maximum stability)

Disables additional PCIe clock transitions.

Use only if:
- spikes still occur
- firmware RX_DCK timeout appears

---

# Tested Hardware

Tested on:

- Gigabyte Z790 D AX
- RTL8852CE
- Intel 12th / 13th / 14th gen
- Linux kernel 6.x
- WiFi 6 routers

Also affects:

- RTL8852CE
- RTL8852AE
- RTL8851BE
- rtw89 driver

---

# Installation

## Automatic Install

```

chmod +x install.sh
sudo ./install.sh

```

Reboot recommended.

---

## Manual Install

```

sudo cp rtw89.conf /etc/modprobe.d/
sudo update-initramfs -u -k all
sudo reboot

```

---

# Configuration Applied

```

options rtw89_core disable_ps_mode=y
options rtw89_pci disable_aspm_l1=y
options rtw89_pci disable_aspm_l1ss=y
options rtw89_pci disable_clkreq=y

```

---

# Verify Fix

```

ping 192.168.1.1 (use default gateway)

```

Expected:

```

time=1.1 ms
time=1.2 ms
time=1.0 ms
time=1.3 ms

```

No spikes above ~5 ms.

---

# Diagnose Firmware Issue

Check for RX timeout:

```

sudo dmesg | grep rtw89

```

Problem signature:

```

[RX_DCK] S1 RXDCK timeout

```

This fix prevents those stalls.

---

# After Kernel Update

Fix persists automatically using:

```

/etc/modprobe.d/rtw89.conf

```

If latency returns:

```

sudo update-initramfs -u -k all
sudo reboot

```

---

# Files Included

- rtw89.conf
- install.sh
- README.md

---

# If This Helped

Please star the repository.

This Realtek issue is widespread but poorly documented.

---

# Tags

rtl8852ce  
rtw89  
realtek  
linux-wifi  
wifi-lag  
wifi-stutter  
packet-loss  
audio-stutter  
z790  
wifi-6
