#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7993344 20c6aa5e8e3f44b35fcc1447ce5670e85e1128be 5087232 d07455495c3f695f7eecd811375b18a324a60756
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7993344:20c6aa5e8e3f44b35fcc1447ce5670e85e1128be; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:d07455495c3f695f7eecd811375b18a324a60756 EMMC:/dev/block/mmcblk0p6 20c6aa5e8e3f44b35fcc1447ce5670e85e1128be 7993344 d07455495c3f695f7eecd811375b18a324a60756:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
