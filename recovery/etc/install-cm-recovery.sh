#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7845888 75552910a5b476d55eab76f2c3de03a8b6ec7e51 5087232 b8357958b2f08fc25892291a178da8c4075bc73b
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7845888:75552910a5b476d55eab76f2c3de03a8b6ec7e51; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:b8357958b2f08fc25892291a178da8c4075bc73b EMMC:/dev/block/mmcblk0p6 75552910a5b476d55eab76f2c3de03a8b6ec7e51 7845888 b8357958b2f08fc25892291a178da8c4075bc73b:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
