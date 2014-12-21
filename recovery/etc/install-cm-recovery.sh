#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7845888 8b957cc753bf2de7effa693b6a712e962ea40182 5087232 a3ddaf51d4537aba2387e5957597f3af0780405c
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7845888:8b957cc753bf2de7effa693b6a712e962ea40182; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:a3ddaf51d4537aba2387e5957597f3af0780405c EMMC:/dev/block/mmcblk0p6 8b957cc753bf2de7effa693b6a712e962ea40182 7845888 a3ddaf51d4537aba2387e5957597f3af0780405c:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
