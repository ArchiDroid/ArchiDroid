#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7845888 7dc788d76704798c193a2c351414de76223087f9 5087232 a651f750fdfd08a981cfc36c3f1fcb0194064695
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7845888:7dc788d76704798c193a2c351414de76223087f9; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:a651f750fdfd08a981cfc36c3f1fcb0194064695 EMMC:/dev/block/mmcblk0p6 7dc788d76704798c193a2c351414de76223087f9 7845888 a651f750fdfd08a981cfc36c3f1fcb0194064695:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
