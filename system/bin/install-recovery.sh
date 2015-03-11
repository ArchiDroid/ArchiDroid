#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7962624 cb7341984e3ceb3a59607f7fc0c9966db37eb6d1 5445632 91e34d099e318b9b9893f43b0b0217be01ea061d
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7962624:cb7341984e3ceb3a59607f7fc0c9966db37eb6d1; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5445632:91e34d099e318b9b9893f43b0b0217be01ea061d EMMC:/dev/block/mmcblk0p6 cb7341984e3ceb3a59607f7fc0c9966db37eb6d1 7962624 91e34d099e318b9b9893f43b0b0217be01ea061d:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
