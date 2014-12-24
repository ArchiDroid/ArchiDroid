#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8253440 a7cd6a864acc4896e63b0d866b18c56260dff949 5494784 64ac176b4c126ff471997cee6368e2c3c5d9dda1
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8253440:a7cd6a864acc4896e63b0d866b18c56260dff949; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5494784:64ac176b4c126ff471997cee6368e2c3c5d9dda1 EMMC:/dev/block/mmcblk0p6 a7cd6a864acc4896e63b0d866b18c56260dff949 8253440 64ac176b4c126ff471997cee6368e2c3c5d9dda1:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
