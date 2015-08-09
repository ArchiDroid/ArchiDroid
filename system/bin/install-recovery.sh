#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 11706368 f39eb9abe505071b59a6c1e821fe3b1473c886e0 13717504 5801cd0a4d366f0dde2e958e80416271d431ee0d
fi

if ! applypatch -c EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel:11706368:f39eb9abe505071b59a6c1e821fe3b1473c886e0; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/platform/msm_sdcc.1/by-name/boot:13717504:5801cd0a4d366f0dde2e958e80416271d431ee0d EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel f39eb9abe505071b59a6c1e821fe3b1473c886e0 11706368 5801cd0a4d366f0dde2e958e80416271d431ee0d:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
