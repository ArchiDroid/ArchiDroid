#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9379840 195bc0adafa5a05ade37bd989d5974b31ffd14fe 6148096 bc0b544a1bbc9921dd255c4d1c1cfd020a4049a7
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9379840:195bc0adafa5a05ade37bd989d5974b31ffd14fe; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6148096:bc0b544a1bbc9921dd255c4d1c1cfd020a4049a7 EMMC:/dev/block/mmcblk0p6 195bc0adafa5a05ade37bd989d5974b31ffd14fe 9379840 bc0b544a1bbc9921dd255c4d1c1cfd020a4049a7:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
