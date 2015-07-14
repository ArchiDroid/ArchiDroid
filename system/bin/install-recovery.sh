#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9506816 187c1e766dfb1e98c3d1d4c3839daa70e5db1346 6213632 c29e2737e637641a150be12571618c57cbaac2c4
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9506816:187c1e766dfb1e98c3d1d4c3839daa70e5db1346; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6213632:c29e2737e637641a150be12571618c57cbaac2c4 EMMC:/dev/block/mmcblk0p6 187c1e766dfb1e98c3d1d4c3839daa70e5db1346 9506816 c29e2737e637641a150be12571618c57cbaac2c4:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
