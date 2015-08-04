#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9596928 d3f6a813dab578e11fac0462d125a07064531e06 6238208 2fb4f9c3a47b7795b7a66b6977c023052013f957
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9596928:d3f6a813dab578e11fac0462d125a07064531e06; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6238208:2fb4f9c3a47b7795b7a66b6977c023052013f957 EMMC:/dev/block/mmcblk0p6 d3f6a813dab578e11fac0462d125a07064531e06 9596928 2fb4f9c3a47b7795b7a66b6977c023052013f957:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
