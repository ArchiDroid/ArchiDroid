#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7845888 86720ca4dd977640086612cc19c001eb8a1d5812 5087232 88f92f2c0c5a3c2c43168e7b8ebd27d50b56bbae
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7845888:86720ca4dd977640086612cc19c001eb8a1d5812; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:88f92f2c0c5a3c2c43168e7b8ebd27d50b56bbae EMMC:/dev/block/mmcblk0p6 86720ca4dd977640086612cc19c001eb8a1d5812 7845888 88f92f2c0c5a3c2c43168e7b8ebd27d50b56bbae:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
