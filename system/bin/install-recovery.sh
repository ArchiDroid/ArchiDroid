#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8712192 775d63ac5021ca4c143cf23a7df57c3a9f045d8e 5642240 0db40aea0c1bffc27f391c72753bff02219815c4
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8712192:775d63ac5021ca4c143cf23a7df57c3a9f045d8e; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5642240:0db40aea0c1bffc27f391c72753bff02219815c4 EMMC:/dev/block/mmcblk0p6 775d63ac5021ca4c143cf23a7df57c3a9f045d8e 8712192 0db40aea0c1bffc27f391c72753bff02219815c4:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
