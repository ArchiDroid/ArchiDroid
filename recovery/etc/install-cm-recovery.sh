#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7993344 75b8f2ec2316244f864de6276208ab89a1678b3a 5087232 aa6c36ed4c32c0db37a951ca6347fd49e25537d7
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7993344:75b8f2ec2316244f864de6276208ab89a1678b3a; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:aa6c36ed4c32c0db37a951ca6347fd49e25537d7 EMMC:/dev/block/mmcblk0p6 75b8f2ec2316244f864de6276208ab89a1678b3a 7993344 aa6c36ed4c32c0db37a951ca6347fd49e25537d7:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
