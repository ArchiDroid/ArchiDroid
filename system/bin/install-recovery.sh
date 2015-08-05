#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9596928 1bbc6dec22e333f263a6e539b15ea6df784bbc8b 6238208 2fb4f9c3a47b7795b7a66b6977c023052013f957
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9596928:1bbc6dec22e333f263a6e539b15ea6df784bbc8b; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6238208:2fb4f9c3a47b7795b7a66b6977c023052013f957 EMMC:/dev/block/mmcblk0p6 1bbc6dec22e333f263a6e539b15ea6df784bbc8b 9596928 2fb4f9c3a47b7795b7a66b6977c023052013f957:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
