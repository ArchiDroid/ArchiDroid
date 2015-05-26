#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 11526144 7fdd2ca3aae7cf48d0eef44a90e6f43b7488e126 13471744 eb195f4c1d3c4a32111ca623fb186ec563bbf212
fi

if ! applypatch -c EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel:11526144:7fdd2ca3aae7cf48d0eef44a90e6f43b7488e126; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/platform/msm_sdcc.1/by-name/boot:13471744:eb195f4c1d3c4a32111ca623fb186ec563bbf212 EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel 7fdd2ca3aae7cf48d0eef44a90e6f43b7488e126 11526144 eb195f4c1d3c4a32111ca623fb186ec563bbf212:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
