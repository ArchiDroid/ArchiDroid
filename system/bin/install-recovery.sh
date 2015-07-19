#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9619456 5cd70e9582cf09312b41666549c8e6ef67613c83 6244352 e7997f099bb0a2ae33ea2b1982be2babfbadb5d8
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9619456:5cd70e9582cf09312b41666549c8e6ef67613c83; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6244352:e7997f099bb0a2ae33ea2b1982be2babfbadb5d8 EMMC:/dev/block/mmcblk0p6 5cd70e9582cf09312b41666549c8e6ef67613c83 9619456 e7997f099bb0a2ae33ea2b1982be2babfbadb5d8:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
