#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7845888 f992a12c9fff25e038ef0ecfbf1d8d6553c4d283 5087232 bdaca125ae10f8ff6d66628786069f7b3ac92255
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7845888:f992a12c9fff25e038ef0ecfbf1d8d6553c4d283; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:bdaca125ae10f8ff6d66628786069f7b3ac92255 EMMC:/dev/block/mmcblk0p6 f992a12c9fff25e038ef0ecfbf1d8d6553c4d283 7845888 bdaca125ae10f8ff6d66628786069f7b3ac92255:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
