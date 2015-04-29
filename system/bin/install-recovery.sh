#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 11464704 520173a2d0b52264470529d2d9864aa4abe2f978 13348864 0c2f0c5b6b842be408f8a364f557918b875b2765
fi

if ! applypatch -c EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel:11464704:520173a2d0b52264470529d2d9864aa4abe2f978; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/platform/msm_sdcc.1/by-name/boot:13348864:0c2f0c5b6b842be408f8a364f557918b875b2765 EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel 520173a2d0b52264470529d2d9864aa4abe2f978 11464704 0c2f0c5b6b842be408f8a364f557918b875b2765:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
