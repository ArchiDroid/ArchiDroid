#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 11767808 b9069bc3c68089215ec1a83d54c8b237acee151b 13803520 f86698d3a82c424293c5360067807c41d04eb897
fi

if ! applypatch -c EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel:11767808:b9069bc3c68089215ec1a83d54c8b237acee151b; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/platform/msm_sdcc.1/by-name/boot:13803520:f86698d3a82c424293c5360067807c41d04eb897 EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel b9069bc3c68089215ec1a83d54c8b237acee151b 11767808 f86698d3a82c424293c5360067807c41d04eb897:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
