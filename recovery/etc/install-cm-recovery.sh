#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7845888 25bb3b529d7456054ae8f17c7cb017d016a16ef6 5087232 cbea807bab487ac2397e19870d22f31326503174
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7845888:25bb3b529d7456054ae8f17c7cb017d016a16ef6; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:cbea807bab487ac2397e19870d22f31326503174 EMMC:/dev/block/mmcblk0p6 25bb3b529d7456054ae8f17c7cb017d016a16ef6 7845888 cbea807bab487ac2397e19870d22f31326503174:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
