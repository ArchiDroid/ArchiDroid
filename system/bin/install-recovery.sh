#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 11767808 52eea8c640897b1f3e9cbb991ca7534047fc5577 13803520 6d582faa58262fe67194b4b77ea843875b1393e6
fi

if ! applypatch -c EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel:11767808:52eea8c640897b1f3e9cbb991ca7534047fc5577; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/platform/msm_sdcc.1/by-name/boot:13803520:6d582faa58262fe67194b4b77ea843875b1393e6 EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel 52eea8c640897b1f3e9cbb991ca7534047fc5577 11767808 6d582faa58262fe67194b4b77ea843875b1393e6:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
