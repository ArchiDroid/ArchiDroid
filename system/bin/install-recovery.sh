#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 10438656 c8372c04a4fdadb510d54f033d4f3a97b8ee4c31 6131712 37cf927a9a52066ac3e86f828a7d723a5aed57ed
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:10438656:c8372c04a4fdadb510d54f033d4f3a97b8ee4c31; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6131712:37cf927a9a52066ac3e86f828a7d723a5aed57ed EMMC:/dev/block/mmcblk0p6 c8372c04a4fdadb510d54f033d4f3a97b8ee4c31 10438656 37cf927a9a52066ac3e86f828a7d723a5aed57ed:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
