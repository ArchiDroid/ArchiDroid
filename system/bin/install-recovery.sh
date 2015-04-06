#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8445952 5a0114da209eb3fa18430337cc05513bf29fbb88 5926912 618ea782543082f6a960ddc7fa134cca18739ce3
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8445952:5a0114da209eb3fa18430337cc05513bf29fbb88; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5926912:618ea782543082f6a960ddc7fa134cca18739ce3 EMMC:/dev/block/mmcblk0p6 5a0114da209eb3fa18430337cc05513bf29fbb88 8445952 618ea782543082f6a960ddc7fa134cca18739ce3:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
