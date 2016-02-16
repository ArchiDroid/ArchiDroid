#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 30588928 3f4269eb4363b4ff29b25a3592fcaf635503768a 27103232 329cdfccf09f3e720d43af4c4b316d05aa1189dc
fi

if ! applypatch -c EMMC:/dev/block/bootdevice/by-name/recovery:30588928:3f4269eb4363b4ff29b25a3592fcaf635503768a; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/bootdevice/by-name/boot:27103232:329cdfccf09f3e720d43af4c4b316d05aa1189dc EMMC:/dev/block/bootdevice/by-name/recovery 3f4269eb4363b4ff29b25a3592fcaf635503768a 30588928 329cdfccf09f3e720d43af4c4b316d05aa1189dc:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
