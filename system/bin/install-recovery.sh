#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 11767808 579eaea8fba1492241181c9a5049887d49c60a3b 13803520 aae23ad25a92a32904ead30f693bfbf11211644b
fi

if ! applypatch -c EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel:11767808:579eaea8fba1492241181c9a5049887d49c60a3b; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/platform/msm_sdcc.1/by-name/boot:13803520:aae23ad25a92a32904ead30f693bfbf11211644b EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel 579eaea8fba1492241181c9a5049887d49c60a3b 11767808 aae23ad25a92a32904ead30f693bfbf11211644b:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
