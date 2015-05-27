#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9504768 b071845425264d10f9d537c675d072dfc4980721 6211584 f56c08d730c2f90f7404f670ac7ecc895982dfc8
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9504768:b071845425264d10f9d537c675d072dfc4980721; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6211584:f56c08d730c2f90f7404f670ac7ecc895982dfc8 EMMC:/dev/block/mmcblk0p6 b071845425264d10f9d537c675d072dfc4980721 9504768 f56c08d730c2f90f7404f670ac7ecc895982dfc8:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
