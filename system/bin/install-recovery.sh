#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9504768 1c85482b1549c0af7dd7304bd865207e64049219 6211584 9e0b643ed879d95e2d72c06aca1c1943dbb43d5d
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9504768:1c85482b1549c0af7dd7304bd865207e64049219; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6211584:9e0b643ed879d95e2d72c06aca1c1943dbb43d5d EMMC:/dev/block/mmcblk0p6 1c85482b1549c0af7dd7304bd865207e64049219 9504768 9e0b643ed879d95e2d72c06aca1c1943dbb43d5d:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
