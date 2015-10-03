#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 10438656 cdb299955f18b6836bb5d339d54ed74fd2abf705 6131712 6a18e879407a5aff89dac5867827561657b2720f
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:10438656:cdb299955f18b6836bb5d339d54ed74fd2abf705; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6131712:6a18e879407a5aff89dac5867827561657b2720f EMMC:/dev/block/mmcblk0p6 cdb299955f18b6836bb5d339d54ed74fd2abf705 10438656 6a18e879407a5aff89dac5867827561657b2720f:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
