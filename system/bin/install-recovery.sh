#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9402368 c8b7fc3cce3cdb02dcb59bde289259e93d45d286 6168576 0213cb2aef6e4e5972bf19cab1fe5b23a3c7fb56
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9402368:c8b7fc3cce3cdb02dcb59bde289259e93d45d286; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6168576:0213cb2aef6e4e5972bf19cab1fe5b23a3c7fb56 EMMC:/dev/block/mmcblk0p6 c8b7fc3cce3cdb02dcb59bde289259e93d45d286 9402368 0213cb2aef6e4e5972bf19cab1fe5b23a3c7fb56:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
