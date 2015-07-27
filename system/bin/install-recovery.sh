#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9619456 536560f5a8724c6661652b854bd6fef5b50a6f1d 6244352 a50d27bd1d623136d6697bbe2ef368931c991a84
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9619456:536560f5a8724c6661652b854bd6fef5b50a6f1d; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6244352:a50d27bd1d623136d6697bbe2ef368931c991a84 EMMC:/dev/block/mmcblk0p6 536560f5a8724c6661652b854bd6fef5b50a6f1d 9619456 a50d27bd1d623136d6697bbe2ef368931c991a84:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
