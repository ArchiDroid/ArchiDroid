#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9504768 dacb337549edf1848cb965e2bb6d0c1a642edddd 6211584 bc12140fa2dee58f18cc068455130fdd14b72d90
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9504768:dacb337549edf1848cb965e2bb6d0c1a642edddd; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6211584:bc12140fa2dee58f18cc068455130fdd14b72d90 EMMC:/dev/block/mmcblk0p6 dacb337549edf1848cb965e2bb6d0c1a642edddd 9504768 bc12140fa2dee58f18cc068455130fdd14b72d90:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
