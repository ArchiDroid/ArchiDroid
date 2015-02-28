#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7960576 4d060f8e0b245d24ea6e317816bb89ed1d20335a 5439488 5c4e328ce424df1c45112639ab6c6d1056e36355
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7960576:4d060f8e0b245d24ea6e317816bb89ed1d20335a; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5439488:5c4e328ce424df1c45112639ab6c6d1056e36355 EMMC:/dev/block/mmcblk0p6 4d060f8e0b245d24ea6e317816bb89ed1d20335a 7960576 5c4e328ce424df1c45112639ab6c6d1056e36355:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
