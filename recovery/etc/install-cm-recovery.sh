#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7845888 366e0fbc7e3eb33b725ffcc44a7d93b3ca704c05 5087232 2429842a2fe2d1ef1877250ca53e92492634c27a
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7845888:366e0fbc7e3eb33b725ffcc44a7d93b3ca704c05; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:2429842a2fe2d1ef1877250ca53e92492634c27a EMMC:/dev/block/mmcblk0p6 366e0fbc7e3eb33b725ffcc44a7d93b3ca704c05 7845888 2429842a2fe2d1ef1877250ca53e92492634c27a:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
