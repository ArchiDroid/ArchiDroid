#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 11706368 49a59e65085a01aa8ec19d4eb551aae9be4173d9 13717504 fa9fe2fd143deefdf8dd1fb84c7ab68c23f81dad
fi

if ! applypatch -c EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel:11706368:49a59e65085a01aa8ec19d4eb551aae9be4173d9; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/platform/msm_sdcc.1/by-name/boot:13717504:fa9fe2fd143deefdf8dd1fb84c7ab68c23f81dad EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel 49a59e65085a01aa8ec19d4eb551aae9be4173d9 11706368 fa9fe2fd143deefdf8dd1fb84c7ab68c23f81dad:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
