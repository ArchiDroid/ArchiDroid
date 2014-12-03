#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7845888 9665d3c4bb79c70d3be668acb5046c9f21e52c69 5087232 218ec24f1604328551c0075e9b760706ab96da8a
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7845888:9665d3c4bb79c70d3be668acb5046c9f21e52c69; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:218ec24f1604328551c0075e9b760706ab96da8a EMMC:/dev/block/mmcblk0p6 9665d3c4bb79c70d3be668acb5046c9f21e52c69 7845888 218ec24f1604328551c0075e9b760706ab96da8a:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
