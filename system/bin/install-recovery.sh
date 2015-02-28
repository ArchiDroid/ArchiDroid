#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7960576 78462715d92c6b49ab09533958540282807f2ceb 5439488 5c4e328ce424df1c45112639ab6c6d1056e36355
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7960576:78462715d92c6b49ab09533958540282807f2ceb; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5439488:5c4e328ce424df1c45112639ab6c6d1056e36355 EMMC:/dev/block/mmcblk0p6 78462715d92c6b49ab09533958540282807f2ceb 7960576 5c4e328ce424df1c45112639ab6c6d1056e36355:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
