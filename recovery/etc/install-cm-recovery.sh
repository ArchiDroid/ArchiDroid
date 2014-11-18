#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7845888 f52ca9aeaf325a6962dea6a1792ffea71fcae1e9 5087232 b5cd255ab27c020eca9dc5021e9ba46ea5df8782
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7845888:f52ca9aeaf325a6962dea6a1792ffea71fcae1e9; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:b5cd255ab27c020eca9dc5021e9ba46ea5df8782 EMMC:/dev/block/mmcblk0p6 f52ca9aeaf325a6962dea6a1792ffea71fcae1e9 7845888 b5cd255ab27c020eca9dc5021e9ba46ea5df8782:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
