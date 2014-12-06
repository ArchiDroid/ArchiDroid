#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7845888 6aed35259b4bc1678181940e262c8a02392d38d8 5087232 db77480947098fe62ca0b11f3bb86a46e8102ceb
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7845888:6aed35259b4bc1678181940e262c8a02392d38d8; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:db77480947098fe62ca0b11f3bb86a46e8102ceb EMMC:/dev/block/mmcblk0p6 6aed35259b4bc1678181940e262c8a02392d38d8 7845888 db77480947098fe62ca0b11f3bb86a46e8102ceb:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
