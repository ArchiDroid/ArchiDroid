#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9390080 9c0a82cc5d1693add556e42003e8e45f92b89f43 6168576 7d9b0cb907f96f6e810f47bd50be2d4437da9e2c
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9390080:9c0a82cc5d1693add556e42003e8e45f92b89f43; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6168576:7d9b0cb907f96f6e810f47bd50be2d4437da9e2c EMMC:/dev/block/mmcblk0p6 9c0a82cc5d1693add556e42003e8e45f92b89f43 9390080 7d9b0cb907f96f6e810f47bd50be2d4437da9e2c:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
