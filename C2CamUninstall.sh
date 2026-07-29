cat << 'EOF' > /root/C2CamUninstall.sh
#!/bin/sh
echo "=== C2CAM: UNINSTALLATION START ==="

# 1. Stop active processes immediately
echo "Stopping active stream services..."
killall go2rtc 2>/dev/null
killall ffmpeg 2>/dev/null

# 2. Remove installed components
echo "Removing C2Cam binaries and configurations..."
[ -f /root/go2rtc ] && rm -f /root/go2rtc
[ -f /root/go2rtc.yaml ] && rm -f /root/go2rtc.yaml
[ -f /etc/init.d/S99c2cam ] && rm -f /etc/init.d/S99c2cam

# 3. Restore backups if they exist to return system to original state
echo "Checking for system backups..."
if [ -d /root/c2cam_backup ]; then
    if [ -f /root/c2cam_backup/go2rtc.yaml.bak ]; then
        mv /root/c2cam_backup/go2rtc.yaml.bak /root/go2rtc.yaml
        echo "[Restore] Original go2rtc.yaml restored."
    fi
    if [ -f /root/c2cam_backup/S99c2cam.bak ]; then
        mv /root/c2cam_backup/S99c2cam.bak /etc/init.d/S99c2cam
        chmod +x /etc/init.d/S99c2cam
        echo "[Restore] Original S99c2cam init script restored."
    fi
    if [ -f /root/c2cam_backup/go2rtc.bin.bak ]; then
        mv /root/c2cam_backup/go2rtc.bin.bak /root/go2rtc
        chmod +x /root/go2rtc
        echo "[Restore] Original go2rtc binary restored."
    fi
    
    # Clean up the backup directory
    rm -rf /root/c2cam_backup
    echo "Backup directory cleaned up."
else
    echo "No backups found. System cleaned to pristine state."
fi

echo "=== C2CAM: UNINSTALLATION COMPLETE ==="
echo "The system has been completely restored."
EOF

# Make the uninstaller executable, run it, and clean up both setup files
chmod +x /root/C2CamUninstall.sh
/root/C2CamUninstall.sh
rm -f /root/C2CamInstall.sh /root/C2CamUninstall.sh
