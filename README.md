# RTL8852CE Linux WiFi Latency + Audio Stutter Fix

![Linux](https://img.shields.io/badge/Linux-supported-green)
![Realtek](https://img.shields.io/badge/Realtek-RTL8852CE-blue)
![Driver](https://img.shields.io/badge/Driver-rtw89-orange)
![Status](https://img.shields.io/badge/Status-Stable-success)

Fix for **Realtek RTL8852CE / rtw89** Wi‑Fi latency spikes, packet loss, and YouTube audio stutter on Linux.

---

# One‑Command Install

```
sudo nano /etc/modprobe.d/rtw89.conf
```

Paste:

```
options rtw89_pci disable_clkreq=y
options rtw89_pci disable_aspm_l1=y
options rtw89_pci disable_aspm_l1ss=y
```

Then:

```
sudo update-initramfs -u
sudo reboot
```

---

Fix for **Realtek RTL8852CE / rtw89** Wi‑Fi latency spikes, packet loss, and YouTube audio stutter on Linux.

This guide documents a **real-world debugging session** and the final stable solution.

---

# Symptoms

- 500–1000 ms ping spikes
- Random packet loss
- YouTube audio stuttering
- Wi‑Fi shows strong signal but unstable
- Gaming lag / jitter
- SSH lag over LAN

Example (before fix):

```
1 ms
2 ms
1050 ms
900 ms
packet loss
```

---

# Hardware

Motherboard:
- Gigabyte Z790 D AX

Wi‑Fi chipset:
- Realtek RTL8852CE

Driver:
- rtw89

Kernel:
- 6.17.0-19-generic (also affects 6.5+)

Router:
- Wi‑Fi 6 (802.11ax)
- 160 MHz enabled

---

# Root Cause

This issue is caused by a **combination** of:

- rtw89 latency bug
- PCIe ASPM power transitions
- Wi‑Fi 6 aggregation stalls
- 160 MHz DFS scanning pauses
- NetworkManager powersave conflicts

---

# Step 1 — Verify the Problem

```
ping 192.168.1.1
```

If you see:

```
1 ms
2 ms
900 ms
1000 ms
```

You are affected.

---

# Step 2 — Router Fix (IMPORTANT)

Disable **Wi‑Fi 6 (802.11ax)** on 5 GHz.

Also:

- Avoid 160 MHz bandwidth
- Use 80 MHz
- Use 802.11ac / n

This removes most spikes.

---

# Step 3 — DO NOT Use NetworkManager Powersave Override

Do NOT use:

```
/etc/NetworkManager/conf.d/wifi-powersave.conf
```

Especially avoid:

```
[connection]
wifi.powersave = 2
```

This fixes ping but **causes audio stalls**.

---

# Final Fix (Stable Solution)

Create:

```
sudo nano /etc/modprobe.d/rtw89.conf
```

Add:

```
options rtw89_pci disable_clkreq=y
options rtw89_pci disable_aspm_l1=y
options rtw89_pci disable_aspm_l1ss=y
```

Then run:

```
sudo update-initramfs -u
sudo reboot
```

---

# Result

Before:

```
1000 ms spikes
packet loss
YouTube stutter
```

After:

```
1–2 ms stable
0% packet loss
smooth YouTube playback
```

---

# Verification

Check ping:

```
ping 192.168.1.1
```

Expected:

```
1.1 ms
1.4 ms
1.6 ms
```

No spikes.

---

# Optional Debug Commands

Check driver:

```
lsmod | grep rtw89
```

Check interface:

```
iw dev
```

Check power save:

```
iw dev wlp3s0 get power_save
```

---

# What NOT To Do

Do NOT use these (causes instability):

```
disable_ps_mode
disable_tx_agg
disable_rx_agg
disable_btc
```

Only use PCIe ASPM fixes.

---

# Affected Hardware

Likely affects:

- RTL8852CE
- RTL8852AE
- RTL8851BE
- rtw89 driver
- Intel Z690/Z790 boards
- Wi‑Fi 6 routers

---

# Search Keywords

rtl8852ce linux lag  
rtw89 latency spikes  
linux wifi 1000ms ping  
realtek rtl8852ce stutter  
linux wifi audio stutter  
rtw89 packet loss linux

---

# License

MIT — use freely.

---

# If this helped

Star the repo ⭐

This issue is very common but poorly documented.

