#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7845888 5a2bcaaef13754f15ad3ae3737d2202636e924e0 5087232 5a8d8acb15d37a8aacfddeccb2fe6923c435a1f8
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7845888:5a2bcaaef13754f15ad3ae3737d2202636e924e0; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:5a8d8acb15d37a8aacfddeccb2fe6923c435a1f8 EMMC:/dev/block/mmcblk0p6 5a2bcaaef13754f15ad3ae3737d2202636e924e0 7845888 5a8d8acb15d37a8aacfddeccb2fe6923c435a1f8:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
