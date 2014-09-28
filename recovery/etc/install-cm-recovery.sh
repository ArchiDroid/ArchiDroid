#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7993344 e9f20a5c6cdaacf4f34e84400cb8269fadebecce 5087232 e31a974ebe3849b7bbf219e23f09f4884bba29ec
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7993344:e9f20a5c6cdaacf4f34e84400cb8269fadebecce; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:e31a974ebe3849b7bbf219e23f09f4884bba29ec EMMC:/dev/block/mmcblk0p6 e9f20a5c6cdaacf4f34e84400cb8269fadebecce 7993344 e31a974ebe3849b7bbf219e23f09f4884bba29ec:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
