#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7964672 e64f0d1593e67d6c1a41972e353a888608588bb5 5445632 1e7666f92dc91d4c1852f358d370ac8ad779e006
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7964672:e64f0d1593e67d6c1a41972e353a888608588bb5; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5445632:1e7666f92dc91d4c1852f358d370ac8ad779e006 EMMC:/dev/block/mmcblk0p6 e64f0d1593e67d6c1a41972e353a888608588bb5 7964672 1e7666f92dc91d4c1852f358d370ac8ad779e006:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
