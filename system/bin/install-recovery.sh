#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9611264 a4d37bc0d7121d8a055f09d75929bae1affabd9f 6254592 ec2f5523ea713c84ac1a7aafc761035c5a284e95
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9611264:a4d37bc0d7121d8a055f09d75929bae1affabd9f; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6254592:ec2f5523ea713c84ac1a7aafc761035c5a284e95 EMMC:/dev/block/mmcblk0p6 a4d37bc0d7121d8a055f09d75929bae1affabd9f 9611264 ec2f5523ea713c84ac1a7aafc761035c5a284e95:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
