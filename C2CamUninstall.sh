#!/bin/sh
echo "=== C2CAM: STEP 1 - TERMINATING SERVICES & CLEANING FILES ==="

# Stop services and kill active streaming processes
if [ -f /etc/init.d/S99c2cam ]; then
    /etc/init.d/S99c2cam stop >/dev/null 2>&1
fi
killall -9 go2rtc 2>/dev/null
killall -9 ffmpeg 2>/dev/null

# Remove all deployed files completely
rm -f /root/go2rtc
rm -f /root/go2rtc.yaml
rm -f /etc/init.d/S99c2cam

echo "=== C2CAM: STEP 2 - RESTORING ORIGINAL SYSTEM STATE ==="

# Revert back to original configuration if backups exist
if [ -f /root/c2cam_backup/go2rtc.yaml.bak ]; then
    mv /root/c2cam_backup/go2rtc.yaml.bak /root/go2rtc.yaml
    echo "[Restore] Original go2rtc.yaml restored."
fi

if [ -f /root/c2cam_backup/S99c2cam.bak ]; then
    mv /root/c2cam_backup/S99c2cam.bak /etc/init.d/S99c2cam
    chmod +x /etc/init.d/S99c2cam
    echo "[Restore] Original init script restored."
fi

if [ -f /root/c2cam_backup/go2rtc.bin.bak ]; then
    mv /root/c2cam_backup/go2rtc.bin.bak /root/go2rtc
    chmod +x /root/go2rtc
    echo "[Restore] Original go2rtc binary restored."
fi

# Wipe out the backup directory entirely
rm -rf /root/c2cam_backup

echo "=== C2CAM: UNINSTALLATION COMPLETE ==="
echo "All C2Cam modifications successfully removed. System is 100% clean."
