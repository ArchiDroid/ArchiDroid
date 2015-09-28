#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 10436608 e9cd0a11c4e415fd63836da8d18505381b5f0c71 6131712 55ed78eadbc4b6a8afdf58753c7f1ce952e84867
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:10436608:e9cd0a11c4e415fd63836da8d18505381b5f0c71; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6131712:55ed78eadbc4b6a8afdf58753c7f1ce952e84867 EMMC:/dev/block/mmcblk0p6 e9cd0a11c4e415fd63836da8d18505381b5f0c71 10436608 55ed78eadbc4b6a8afdf58753c7f1ce952e84867:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
