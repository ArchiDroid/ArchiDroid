#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7845888 879f9174ded808ff73691a545b6edb91f1ff88d1 5087232 62fb5a12743789da8ca1e9844e30475b7255485d
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7845888:879f9174ded808ff73691a545b6edb91f1ff88d1; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:62fb5a12743789da8ca1e9844e30475b7255485d EMMC:/dev/block/mmcblk0p6 879f9174ded808ff73691a545b6edb91f1ff88d1 7845888 62fb5a12743789da8ca1e9844e30475b7255485d:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
