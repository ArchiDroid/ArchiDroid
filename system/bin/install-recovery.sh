#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 11743232 90cec130bfe77a74200358086936e2122b34bccf 13758464 3e898376b7eb11ad65493ea5822ea44d68c129bd
fi

if ! applypatch -c EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel:11743232:90cec130bfe77a74200358086936e2122b34bccf; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/platform/msm_sdcc.1/by-name/boot:13758464:3e898376b7eb11ad65493ea5822ea44d68c129bd EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel 90cec130bfe77a74200358086936e2122b34bccf 11743232 3e898376b7eb11ad65493ea5822ea44d68c129bd:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
