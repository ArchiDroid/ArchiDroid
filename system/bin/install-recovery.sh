#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9390080 d89ce67cc367dfc9303e38f61d71a64f3c2becec 6168576 2f38837482b0617ee2b458bef13341d0c32875e5
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9390080:d89ce67cc367dfc9303e38f61d71a64f3c2becec; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6168576:2f38837482b0617ee2b458bef13341d0c32875e5 EMMC:/dev/block/mmcblk0p6 d89ce67cc367dfc9303e38f61d71a64f3c2becec 9390080 2f38837482b0617ee2b458bef13341d0c32875e5:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
