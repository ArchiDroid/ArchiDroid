#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7960576 039405db44e923a954d7a7827ed986d5771fad0c 5439488 5c4e328ce424df1c45112639ab6c6d1056e36355
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7960576:039405db44e923a954d7a7827ed986d5771fad0c; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5439488:5c4e328ce424df1c45112639ab6c6d1056e36355 EMMC:/dev/block/mmcblk0p6 039405db44e923a954d7a7827ed986d5771fad0c 7960576 5c4e328ce424df1c45112639ab6c6d1056e36355:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
