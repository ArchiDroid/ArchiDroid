#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 30588928 1ab3b557e60d13b44157e23858f5812cafe6c7cc 27103232 636d39d593a834daf4cc5b8d95bab45f13be40ae
fi

if ! applypatch -c EMMC:/dev/block/bootdevice/by-name/recovery:30588928:1ab3b557e60d13b44157e23858f5812cafe6c7cc; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/bootdevice/by-name/boot:27103232:636d39d593a834daf4cc5b8d95bab45f13be40ae EMMC:/dev/block/bootdevice/by-name/recovery 1ab3b557e60d13b44157e23858f5812cafe6c7cc 30588928 636d39d593a834daf4cc5b8d95bab45f13be40ae:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
