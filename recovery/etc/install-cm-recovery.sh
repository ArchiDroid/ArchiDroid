#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7845888 dfbdf67a25414a19cbe9dbaf16f5f80cbba24aa4 5087232 f4ad305b9188e5751e5dad99cfd98f8830999964
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7845888:dfbdf67a25414a19cbe9dbaf16f5f80cbba24aa4; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:f4ad305b9188e5751e5dad99cfd98f8830999964 EMMC:/dev/block/mmcblk0p6 dfbdf67a25414a19cbe9dbaf16f5f80cbba24aa4 7845888 f4ad305b9188e5751e5dad99cfd98f8830999964:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
