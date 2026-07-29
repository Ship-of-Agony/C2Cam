# C2Cam C(reality) 2 Cam

A stable, ultra-low-overhead 1080p USB camera streaming solution designed specifically for the **Creality K2 Series** (Allwinner T113-i, 32-bit ARM). 

Unlike heavy transcoding setups that push the printer's CPU to its limits and cause thermal throttling, **C2Cam** utilizes raw stream copying (`-c:v copy`). This drops the CPU transcoding load to 0%, ensuring thermal stability and minimal latency. Additionally, it implements a robust Python-native download bypass to overcome broken SSL/`wget` certificates on Creality OS, alongside an intelligent, dynamic boot loop that waits for your camera hardware (`/dev/video2`) to initialize safely.

I used this Low Budget Cam-borad for my DIY Projekt: [Innomaker 1080p](https://www.amazon.com/s?k=innomaker+1080p&crid=11FNIO0SOXRHY&sprefix=%2Caps%2C174&ref=nb_sb_ss_recent_1_0_recent)

---

## 🚀 Installation & Deployment Guide

> **Please Note:** you absolutely need root rights on your printer and, if necessary, the camera fix from [DnG](https://github.com/DnG-Crafts/K2-Camera).


Follow these step-by-step instructions to deploy the streaming service via SSH.

### Step 1: Connect to your Printer via PuTTY
1. Open **PuTTY** on your computer.
2. In the **Host Name (or IP address)** field, type your Creality K2 IP address (e.g., `192.168.1.100`).
3. Ensure the connection type is set to **SSH** (Port `22`).
4. Click **Open**.
5. Log in using the system root credentials:
   * **login as:** `root`
   * **Password:** `creality_2024`

### Step 2: Copy the Script

**[C2CamInstall.sh](https://raw.githubusercontent.com/Ship-of-Agony/C2Cam/refs/heads/main/C2CamInstall.sh)**
and run it via PuttY with [Enter].

### Step 3: Configure your Web Interface (Fluidd / Mainsail)

The stream activates immediately on port 8081 upon successful installation. To mount it into your dashboard:

Navigate to Settings -> Cameras inside Fluidd or Mainsail.

Click Add Camera and choose HTTP-Site.

Set the stream URL to the following path (replace [YOUR_PRINTER_IP] with your printer's real IP address):

  * http://[YOUR_PRINTER_IP]:8081/stream.html?src=c2cam = Stream
  * http://[YOUR_PRINTER_IP]:8081/api/frame.jpeg?src=c2cam = Snapshot

🛠️ **Management & Service Persistence**

Persistence is configured out-of-the-box via a dedicated system service script (/etc/init.d/S99c2cam).

When your printer boots up, the script automatically begins a dynamic hardware detection loop. It checks for the device node /dev/video2 every 2 seconds, waiting up to a maximum of 45 seconds for your USB hardware to fully initialize before launching go2rtc. This eliminates race-condition boot crashes completely.

If you ever need to manually handle the service without rebooting the machine, run the init script directly from your terminal:
Bash

/etc/init.d/S99c2cam restart

**Available options: start | stop | restart**

  * /etc/init.d/S99c2cam start
  * /etc/init.d/S99c2cam stop
  * /etc/init.d/S99c2cam restart

❌ **Uninstallation**

If you ever wish to remove the modifications, C2Cam guarantees a 100% clean rollback. The script creates systemic backups before any changes are written. Running the uninstaller will wipe all binary files, erase scripts, and restore previous system parameters to their exact native state.

### Copy the Script

**[C2CamUninstall.sh](https://raw.githubusercontent.com/Ship-of-Agony/C2Cam/refs/heads/main/C2CamUninstall.sh)**
and run it via PuttY with [Enter].

Your operating system is now completely untainted and pristine.
