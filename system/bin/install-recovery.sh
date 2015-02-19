#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7960576 4f689b4040503b35ea11895df1464cfa1054395d 5439488 30cba0fda5c5a6370af9611e7742be450a8a4219
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7960576:4f689b4040503b35ea11895df1464cfa1054395d; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5439488:30cba0fda5c5a6370af9611e7742be450a8a4219 EMMC:/dev/block/mmcblk0p6 4f689b4040503b35ea11895df1464cfa1054395d 7960576 30cba0fda5c5a6370af9611e7742be450a8a4219:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
