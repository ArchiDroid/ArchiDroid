#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7993344 ef563d18f87b65b0e127c1d291ea6900a5a80ff6 5087232 b77235eb7572b33ac318c7fdf2fd3e2735210aa0
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7993344:ef563d18f87b65b0e127c1d291ea6900a5a80ff6; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:b77235eb7572b33ac318c7fdf2fd3e2735210aa0 EMMC:/dev/block/mmcblk0p6 ef563d18f87b65b0e127c1d291ea6900a5a80ff6 7993344 b77235eb7572b33ac318c7fdf2fd3e2735210aa0:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
