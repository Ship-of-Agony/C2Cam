cat << 'EOF' > /root/C2CamUninstall.sh
#!/bin/sh
echo "=== C2CAM UNINSTALLER: STEP 1 - STOPPING SERVICES ==="
if [ -f /etc/init.d/S99c2cam ]; then
    /etc/init.d/S99c2cam stop
else
    echo "Stopping any remaining streaming processes..."
    killall go2rtc 2>/dev/null
    killall ffmpeg 2>/dev/null
fi

echo "=== C2CAM UNINSTALLER: STEP 2 - REMOVING AUTOSTART ENTRY ==="
if [ -f /etc/rc.local ]; then
    # Removes only the specific line added by the installation script
    sed -i '\#/etc/init.d/S99c2cam start &#d' /etc/rc.local
    echo "Removed autostart entry from /etc/rc.local."
fi

echo "=== C2CAM UNINSTALLER: STEP 3 - REMOVING DEPLOYED FILES ==="
rm -f /etc/init.d/S99c2cam
rm -f /root/go2rtc
rm -f /root/go2rtc.yaml
echo "Deleted binary, configuration, and init script files."

echo "=== C2CAM UNINSTALLER: STEP 4 - REMOVING CONTROLLING SCRIPTS ==="
# Self-destruct helper (removes the install script)
rm -f /root/C2CamInstall.sh
echo "Removed installer script."

echo "=== C2CAM: UNINSTALLATION COMPLETE ==="
echo "Note: Your backups are still safely stored in /root/c2cam_backup/"
EOF

chmod +x /root/C2CamUninstall.sh
