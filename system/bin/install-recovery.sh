#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9506816 33ec774ac8d947766fcb77fc11e6bceef9d8b659 6213632 c29e2737e637641a150be12571618c57cbaac2c4
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9506816:33ec774ac8d947766fcb77fc11e6bceef9d8b659; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6213632:c29e2737e637641a150be12571618c57cbaac2c4 EMMC:/dev/block/mmcblk0p6 33ec774ac8d947766fcb77fc11e6bceef9d8b659 9506816 c29e2737e637641a150be12571618c57cbaac2c4:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
