#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8921088 c11f7298c147d1a2e00078e7712f76f5dda1b700 5701632 30616ccdffcfd66183e929014619039fe8ee1b44
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8921088:c11f7298c147d1a2e00078e7712f76f5dda1b700; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5701632:30616ccdffcfd66183e929014619039fe8ee1b44 EMMC:/dev/block/mmcblk0p6 c11f7298c147d1a2e00078e7712f76f5dda1b700 8921088 30616ccdffcfd66183e929014619039fe8ee1b44:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
