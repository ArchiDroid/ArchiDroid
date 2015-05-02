#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9375744 61dbba33875fe9f5a4bd284fe1a79caefabf0180 6141952 f7b5dac2c6a19b2040ee4634c8b9bc31c5778b98
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9375744:61dbba33875fe9f5a4bd284fe1a79caefabf0180; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6141952:f7b5dac2c6a19b2040ee4634c8b9bc31c5778b98 EMMC:/dev/block/mmcblk0p6 61dbba33875fe9f5a4bd284fe1a79caefabf0180 9375744 f7b5dac2c6a19b2040ee4634c8b9bc31c5778b98:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
