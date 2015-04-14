#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9390080 91aad10f98db814f496a5d5255980e1bcc7dc1f7 6168576 f57c7f61515fab89ebea229f12446f55526d8f93
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9390080:91aad10f98db814f496a5d5255980e1bcc7dc1f7; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6168576:f57c7f61515fab89ebea229f12446f55526d8f93 EMMC:/dev/block/mmcblk0p6 91aad10f98db814f496a5d5255980e1bcc7dc1f7 9390080 f57c7f61515fab89ebea229f12446f55526d8f93:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
