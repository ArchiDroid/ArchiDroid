#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7845888 200f29cf28cb7e18fdf5193ee71a0f7f730d05a1 5087232 e76fc1dcfd88ea570228680e1aeff60d3b3282f4
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7845888:200f29cf28cb7e18fdf5193ee71a0f7f730d05a1; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:e76fc1dcfd88ea570228680e1aeff60d3b3282f4 EMMC:/dev/block/mmcblk0p6 200f29cf28cb7e18fdf5193ee71a0f7f730d05a1 7845888 e76fc1dcfd88ea570228680e1aeff60d3b3282f4:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
