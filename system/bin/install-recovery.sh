#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8921088 677398fcde3b196fa12213547603defcefea43ee 5701632 4e688757bca96bb6260ee9206f62b60d28a2f6fb
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8921088:677398fcde3b196fa12213547603defcefea43ee; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5701632:4e688757bca96bb6260ee9206f62b60d28a2f6fb EMMC:/dev/block/mmcblk0p6 677398fcde3b196fa12213547603defcefea43ee 8921088 4e688757bca96bb6260ee9206f62b60d28a2f6fb:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
