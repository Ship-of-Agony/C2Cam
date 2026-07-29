cat << 'EOF' > /root/C2CamUninstall.sh
#!/bin/sh
echo "=== C2CAM: UNINSTALLATION START ==="

echo "Stopping active stream services..."
/etc/init.d/S99c2cam stop 2>/dev/null
killall go2rtc 2>/dev/null
killall ffmpeg 2>/dev/null

echo "Removing C2Cam autostart entry from rcS..."
if [ -f /etc/init.d/rcS ]; then
    sed -i '\#/etc/init.d/S99c2cam start#d' /etc/init.d/rcS
fi

echo "Removing C2Cam binaries and configurations..."
[ -f /root/go2rtc ] && rm -f /root/go2rtc
[ -f /root/go2rtc.yaml ] && rm -f /root/go2rtc.yaml
[ -f /etc/init.d/S99c2cam ] && rm -f /etc/init.d/S99c2cam

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
    if [ -f /root/c2cam_backup/rcS.bak ]; then
        mv /root/c2cam_backup/rcS.bak /etc/init.d/rcS
        echo "[Restore] Original rcS startup file restored."
    fi
    rm -rf /root/c2cam_backup
    echo "Backup directory cleaned up."
else
    echo "No backups found. System cleaned to pristine state."
fi

echo "=== C2CAM: UNINSTALLATION COMPLETE ==="
echo "The system has been completely restored."
EOF

chmod +x /root/C2CamUninstall.sh
/root/C2CamUninstall.sh
rm -f /root/C2CamInstall.sh /root/C2CamUninstall.sh
