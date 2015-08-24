#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8925184 a8a63b5b81ce1e0b6289f5c1faca3cc820841f3c 6000640 7f1e4260ca55bb7f18b25b19b5014f81bcad3408
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8925184:a8a63b5b81ce1e0b6289f5c1faca3cc820841f3c; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6000640:7f1e4260ca55bb7f18b25b19b5014f81bcad3408 EMMC:/dev/block/mmcblk0p6 a8a63b5b81ce1e0b6289f5c1faca3cc820841f3c 8925184 7f1e4260ca55bb7f18b25b19b5014f81bcad3408:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
