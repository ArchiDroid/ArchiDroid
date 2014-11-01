#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7845888 2f83957d6b96f695a55ab5d701ba300c528786e1 5087232 cb20d0fda8bcf8d2c18f2d7869b7272c2e98ce37
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7845888:2f83957d6b96f695a55ab5d701ba300c528786e1; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:cb20d0fda8bcf8d2c18f2d7869b7272c2e98ce37 EMMC:/dev/block/mmcblk0p6 2f83957d6b96f695a55ab5d701ba300c528786e1 7845888 cb20d0fda8bcf8d2c18f2d7869b7272c2e98ce37:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
