#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7960576 c16f4bc157be6bf3e33e6052e3a1c97a209b3707 5439488 fc69808d32cfaf30ee5cfe1defdd343df73abec8
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7960576:c16f4bc157be6bf3e33e6052e3a1c97a209b3707; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5439488:fc69808d32cfaf30ee5cfe1defdd343df73abec8 EMMC:/dev/block/mmcblk0p6 c16f4bc157be6bf3e33e6052e3a1c97a209b3707 7960576 fc69808d32cfaf30ee5cfe1defdd343df73abec8:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
