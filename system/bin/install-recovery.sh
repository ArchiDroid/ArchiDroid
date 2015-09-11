#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 10436608 40829db729b56dff4645e907e360e8eaefc84784 6131712 5ae92451b05949e310daea76848f8e744d9de73c
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:10436608:40829db729b56dff4645e907e360e8eaefc84784; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6131712:5ae92451b05949e310daea76848f8e744d9de73c EMMC:/dev/block/mmcblk0p6 40829db729b56dff4645e907e360e8eaefc84784 10436608 5ae92451b05949e310daea76848f8e744d9de73c:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
