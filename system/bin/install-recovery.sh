#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7974912 c24aa4284739aa33137917de66b44d19fc771b29 5445632 5cf3fbbf9c74a848e7c889a877175c3f1b6b901c
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7974912:c24aa4284739aa33137917de66b44d19fc771b29; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5445632:5cf3fbbf9c74a848e7c889a877175c3f1b6b901c EMMC:/dev/block/mmcblk0p6 c24aa4284739aa33137917de66b44d19fc771b29 7974912 5cf3fbbf9c74a848e7c889a877175c3f1b6b901c:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
