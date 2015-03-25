#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8921088 2fe2719e8dfedb41ff56273248d862d491fd1562 5701632 1fbc489f9e0373ab7a845e0ef98522a599fc7e08
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8921088:2fe2719e8dfedb41ff56273248d862d491fd1562; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5701632:1fbc489f9e0373ab7a845e0ef98522a599fc7e08 EMMC:/dev/block/mmcblk0p6 2fe2719e8dfedb41ff56273248d862d491fd1562 8921088 1fbc489f9e0373ab7a845e0ef98522a599fc7e08:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
