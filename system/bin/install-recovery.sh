#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9402368 db4109982fef549012933e2f1a0dd48df1472ef8 6168576 470606f3d049959bcedb3185c203f9f1ee8505bd
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9402368:db4109982fef549012933e2f1a0dd48df1472ef8; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6168576:470606f3d049959bcedb3185c203f9f1ee8505bd EMMC:/dev/block/mmcblk0p6 db4109982fef549012933e2f1a0dd48df1472ef8 9402368 470606f3d049959bcedb3185c203f9f1ee8505bd:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
