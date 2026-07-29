cat << 'EOF' > /root/C2CamInstall.sh
#!/bin/sh
echo "=== C2CAM: STEP 1 - AUTOMATIC SYSTEM BACKUP ==="
mkdir -p /root/c2cam_backup

if [ -f /root/go2rtc.yaml ]; then
    cp /root/go2rtc.yaml /root/c2cam_backup/go2rtc.yaml.bak
    echo "[Backup] Existing go2rtc.yaml backed up."
fi
if [ -f /etc/init.d/S99c2cam ]; then
    cp /etc/init.d/S99c2cam /root/c2cam_backup/S99c2cam.bak
    echo "[Backup] Existing S99c2cam init script backed up."
fi
if [ -f /root/go2rtc ]; then
    cp /root/go2rtc /root/c2cam_backup/go2rtc.bin.bak
    echo "[Backup] Existing go2rtc binary backed up."
fi

echo "=== C2CAM: STEP 2 - ROBUST DOWNLOAD VIA PYTHON BYPASS ==="
echo "Retrieving 32-bit ARMv7 go2rtc binary from GitHub..."

python -c '
import urllib2
url = "https://github.com/AlexxIT/go2rtc/releases/latest/download/go2rtc_linux_arm"
req = urllib2.Request(url, headers={"User-Agent": "Mozilla/5.0"})
data = urllib2.urlopen(req).read()
with open("/root/go2rtc", "wb") as f:
    f.write(data)
' 2>/dev/null || python3 -c '
import urllib.request, ssl
url = "https://github.com/AlexxIT/go2rtc/releases/latest/download/go2rtc_linux_arm"
ctx = ssl._create_unverified_context()
req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
data = urllib.request.urlopen(req, context=ctx).read()
with open("/root/go2rtc", "wb") as f:
    f.write(data)
'

chmod +x /root/go2rtc

echo "=== C2CAM: STEP 3 - CONFIGURING ZERO-OVERHEAD STREAM COPY ==="
cat << 'CGF' > /root/go2rtc.yaml
streams:
  c2cam: exec:ffmpeg -loglevel quiet -f v4l2 -input_format mjpeg -video_size 1920x1080 -i /dev/video2 -c:v copy -f mpjpeg -

api:
  listen: ":8081"
CGF

echo "=== C2CAM: STEP 4 - CREATING SMART BOOT ROUTINE ==="
cat << 'CGF' > /etc/init.d/S99c2cam
#!/bin/sh

case "$1" in
  start)
    echo "Starting C2Cam Service..."
    TIMEOUT=45
    COUNTER=0
    echo "Checking for USB camera hardware readiness..."
    while [ ! -c /dev/video2 ] && [ $COUNTER -lt $TIMEOUT ]; do
        sleep 2
        COUNTER=$((COUNTER + 2))
        echo "Waiting for USB camera to initialize... (${COUNTER}s)"
    done

    if [ -c /dev/video2 ]; then
        echo "USB Camera detected successfully!"
    else
        echo "Warning: Timeout reached. Attempting stream launch anyway."
    fi

    /root/go2rtc -config /root/go2rtc.yaml >/dev/null 2>&1 &
    ;;
  stop)
    echo "Stopping C2Cam Service..."
    killall go2rtc 2>/dev/null
    killall ffmpeg 2>/dev/null
    ;;
  restart)
    $0 stop
    sleep 2
    $0 start
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
    ;;
esac
exit 0
CGF

chmod +x /etc/init.d/S99c2cam
echo "Launching C2Cam immediately..."
/root/go2rtc -config /root/go2rtc.yaml >/dev/null 2>&1 &

echo "=== C2CAM: INSTALLATION COMPLETE ==="
echo "Stream is now active on port 8081!"
echo "Fluidd / MainSail Stream URL: http://[YOUR_PRINTER_IP]:8081/stream.html?src=c2cam"
EOF

chmod +x /root/C2CamInstall.sh
/root/C2CamInstall.sh
