#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9596928 e01b4ad60a0d1a3d2e908c166d05a6652690c4c2 6238208 968608cee462751a792434a900367ea1e4f2df07
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9596928:e01b4ad60a0d1a3d2e908c166d05a6652690c4c2; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6238208:968608cee462751a792434a900367ea1e4f2df07 EMMC:/dev/block/mmcblk0p6 e01b4ad60a0d1a3d2e908c166d05a6652690c4c2 9596928 968608cee462751a792434a900367ea1e4f2df07:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
