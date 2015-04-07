#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9390080 30ee49a27dd12838a4c0c1bbe8b700a6838c53c2 6168576 8c31bc5ecfd5bf0305d4a5266537c1c3cfc9862a
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9390080:30ee49a27dd12838a4c0c1bbe8b700a6838c53c2; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6168576:8c31bc5ecfd5bf0305d4a5266537c1c3cfc9862a EMMC:/dev/block/mmcblk0p6 30ee49a27dd12838a4c0c1bbe8b700a6838c53c2 9390080 8c31bc5ecfd5bf0305d4a5266537c1c3cfc9862a:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
