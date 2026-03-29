# RTL8852CE Linux WiFi Latency + Audio Stutter Fix (Balanced)

A **balanced latency fix** for Realtek **RTL8852CE / rtw89** on Linux.
This solution removes **WiFi latency spikes and audio stutter** without forcing CPU performance mode or disabling WiFi 6.

Unlike aggressive workarounds, this approach **targets only the problematic WiFi power states**, keeping the rest of the system efficient.

---

## What This Fix Resolves

* 500–1000 ms ping spikes
* Random packet loss
* YouTube / video audio stuttering
* Intermittent SSH lag
* Gaming jitter
* WiFi stable signal but unstable latency

---

## What This Fix Does

This configuration disables **problematic Realtek power states only**:

* WiFi card power saving
* PCIe ASPM L1 state
* PCIe L1 Substates (L1SS)

This keeps:

* CPU power scaling intact
* PCIe clock management intact
* WiFi 6 (802.11ax) support
* Normal system thermals
* Low idle power usage

This provides **stable latency without aggressive system-wide changes**.

---

## Tested Hardware

Tested on:

* Gigabyte Z790 D AX
* Realtek RTL8852CE
* Intel 12th/13th/14th gen platforms
* Linux kernel 6.x
* WiFi 6 routers

Also likely affects:

* RTL8852CE
* RTL8852AE
* RTL8851BE
* rtw89 driver

---

## Installation

### Automatic Install (Recommended)

```
chmod +x install.sh
sudo ./install.sh
```

Reboot after installation.

---

### Manual Install

```
sudo cp rtw89.conf /etc/modprobe.d/
sudo update-initramfs -u
sudo reboot
```

---

## Configuration Applied

The following parameters are used:

```
options rtw89_core disable_ps_mode=y
options rtw89_pci disable_aspm_l1=y
options rtw89_pci disable_aspm_l1ss=y
```

These disable unstable power transitions responsible for latency spikes.

---

## Verify the Fix

Check latency to your router:

```
ping 192.168.1.1 (default gateway)
```

Expected output:

```
64 bytes time=1.1 ms
64 bytes time=1.3 ms
64 bytes time=1.2 ms
64 bytes time=1.4 ms
```

No spikes above ~5 ms.

---

## Before vs After

Before:

* 1000 ms ping spikes
* Audio stutter
* Packet loss
* Random lag

After:

* Stable 1–2 ms latency
* Smooth audio playback
* No packet loss
* Consistent WiFi performance

---

## Diagnose Your System

Check loaded driver:

```
lsmod | grep rtw89
```

Check WiFi interface:

```
iw dev
```

Check power saving:

```
iw dev wlp3s0 get power_save
```

Reload driver manually:

```
sudo modprobe -r rtw89_8852ce rtw89_pci rtw89_core
sudo modprobe rtw89_8852ce
```

---

## Root Cause

The issue is caused by interaction between:

* rtw89 driver power saving
* PCIe ASPM transitions
* WiFi firmware latency stalls
* aggregation timing issues

These create **periodic latency spikes** even with strong signal.

This fix disables the unstable transitions.

---

## Kernel Updates

The fix is persistent across kernel updates because it uses:

```
/etc/modprobe.d/rtw89.conf
```

If latency returns after an update:

```
sudo update-initramfs -u
sudo reboot
```

---

## Files Included

* rtw89.conf
* install.sh
* README.md

---

## Affected Platforms

Commonly reported on:

* Intel Z690 / Z790
* WiFi 6 routers
* Linux kernel 6.x
* Desktop motherboards with RTL8852CE

---

## If This Helped

Please star the repository.

This issue is widespread but poorly documented.

---

## Tags

- rtl8852ce
- rtw89
- realtek
- realtek-wifi
- linux-wifi
- wifi-lag
- wifi-stutter
- packet-loss
- audio-stutter
- pipewire
- z790
- wifi-6
