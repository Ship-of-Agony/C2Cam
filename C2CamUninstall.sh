cat << 'EOF' > /root/C2CamUninstall.sh
#!/bin/sh
echo "=== C2CAM: UNINSTALLATION START ==="

echo "Stopping active stream services..."
/etc/init.d/S99c2cam stop 2>/dev/null
killall go2rtc 2>/dev/null
killall ffmpeg 2>/dev/null

echo "Removing C2Cam autostart entry from rc.local..."
if [ -f /etc/rc.local ]; then
    sed -i '\#/etc/init.d/S99c2cam start#d' /etc/rc.local
fi

echo "Removing C2Cam binaries and configurations..."
[ -f /root/go2rtc ] && rm -f /root/go2rtc
[ -f /root/go2rtc.yaml ] && rm -f /root/go2rtc.yaml
[ -f /etc/init.d/S99c2cam ] && rm -f /etc/init.d/S99c2cam

echo "Checking for system backups..."
if [ -d /root/c2cam_backup ]; then
    [ -f /root/c2cam_backup/go2rtc.yaml.bak ] && mv /root/c2cam_backup/go2rtc.yaml.bak /root/go2rtc.yaml
    [ -f /root/c2cam_backup/S99c2cam.bak ] && mv /root/c2cam_backup/S99c2cam.bak /etc/init.d/S99c2cam && chmod +x /etc/init.d/S99c2cam
    [ -f /root/c2cam_backup/go2rtc.bin.bak ] && mv /root/c2cam_backup/go2rtc.bin.bak /root/go2rtc && chmod +x /root/go2rtc
    [ -f /root/c2cam_backup/rc.local.bak ] && mv /root/c2cam_backup/rc.local.bak /etc/rc.local
    rm -rf /root/c2cam_backup
    echo "System backups successfully restored."
else
    echo "No backups found. Clean rollback completed."
fi

echo "=== C2CAM: UNINSTALLATION COMPLETE ==="
EOF

chmod +x /root/C2CamUninstall.sh
/root/C2CamUninstall.sh
rm -f /root/C2CamInstall.sh /root/C2CamUninstall.sh
