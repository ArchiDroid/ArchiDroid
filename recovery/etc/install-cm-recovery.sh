#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7989248 788cdac1036b3d00bce88126049a18ea2d51d9d8 5087232 477131ee6ef9007c1cf2be09f7e309659b84e67c
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7989248:788cdac1036b3d00bce88126049a18ea2d51d9d8; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:477131ee6ef9007c1cf2be09f7e309659b84e67c EMMC:/dev/block/mmcblk0p6 788cdac1036b3d00bce88126049a18ea2d51d9d8 7989248 477131ee6ef9007c1cf2be09f7e309659b84e67c:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
