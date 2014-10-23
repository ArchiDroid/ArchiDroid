#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7845888 46b2d59909e28f7102acb7511c6fb9cd3729a18a 5087232 db1dc5ff6a1aef642c49c2ce5a0b1c68dc225f8e
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7845888:46b2d59909e28f7102acb7511c6fb9cd3729a18a; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:db1dc5ff6a1aef642c49c2ce5a0b1c68dc225f8e EMMC:/dev/block/mmcblk0p6 46b2d59909e28f7102acb7511c6fb9cd3729a18a 7845888 db1dc5ff6a1aef642c49c2ce5a0b1c68dc225f8e:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
