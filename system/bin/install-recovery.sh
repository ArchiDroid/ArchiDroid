#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8919040 e661ecc8bf20f00153e543f6e270b24afc8671ce 5699584 8605ecd32ce7752edd54fb60134e2de215f4cdc1
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8919040:e661ecc8bf20f00153e543f6e270b24afc8671ce; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5699584:8605ecd32ce7752edd54fb60134e2de215f4cdc1 EMMC:/dev/block/mmcblk0p6 e661ecc8bf20f00153e543f6e270b24afc8671ce 8919040 8605ecd32ce7752edd54fb60134e2de215f4cdc1:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
