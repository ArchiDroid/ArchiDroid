#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9596928 6cfb3adf928f6922989f0b7778a5cf873de878ad 6238208 fafb23abb905c62cebf1f144292a2eecffa01288
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9596928:6cfb3adf928f6922989f0b7778a5cf873de878ad; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6238208:fafb23abb905c62cebf1f144292a2eecffa01288 EMMC:/dev/block/mmcblk0p6 6cfb3adf928f6922989f0b7778a5cf873de878ad 9596928 fafb23abb905c62cebf1f144292a2eecffa01288:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
