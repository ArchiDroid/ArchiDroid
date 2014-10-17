#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7845888 68ab767c3c9608fc84bdc3e31b351ca976150889 5087232 5ce0bf1f6cacf40e5f195b25c6383b87dc9161f6
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7845888:68ab767c3c9608fc84bdc3e31b351ca976150889; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:5ce0bf1f6cacf40e5f195b25c6383b87dc9161f6 EMMC:/dev/block/mmcblk0p6 68ab767c3c9608fc84bdc3e31b351ca976150889 7845888 5ce0bf1f6cacf40e5f195b25c6383b87dc9161f6:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
