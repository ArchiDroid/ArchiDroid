#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 11767808 12c3ea2b8b25368b9222713c51e89d8f4d78a13c 13807616 b11afff27162f83fd780f9c69a1dc0f91f330f01
fi

if ! applypatch -c EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel:11767808:12c3ea2b8b25368b9222713c51e89d8f4d78a13c; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/platform/msm_sdcc.1/by-name/boot:13807616:b11afff27162f83fd780f9c69a1dc0f91f330f01 EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel 12c3ea2b8b25368b9222713c51e89d8f4d78a13c 11767808 b11afff27162f83fd780f9c69a1dc0f91f330f01:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
