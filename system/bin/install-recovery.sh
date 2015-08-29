#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 11767808 6f7ba77ad454e3027a9feaf81e3b6015bfea9c4e 13803520 b66eb7b42fdb561d13bb52a8692f53c93f117cda
fi

if ! applypatch -c EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel:11767808:6f7ba77ad454e3027a9feaf81e3b6015bfea9c4e; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/platform/msm_sdcc.1/by-name/boot:13803520:b66eb7b42fdb561d13bb52a8692f53c93f117cda EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel 6f7ba77ad454e3027a9feaf81e3b6015bfea9c4e 11767808 b66eb7b42fdb561d13bb52a8692f53c93f117cda:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
