#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 11464704 2ef16d497bdbc2d819e57e5a5db5ffbc603e83d8 13348864 f4afe782f3e4bbc0e92c2a99b91425dd82ce49df
fi

if ! applypatch -c EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel:11464704:2ef16d497bdbc2d819e57e5a5db5ffbc603e83d8; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/platform/msm_sdcc.1/by-name/boot:13348864:f4afe782f3e4bbc0e92c2a99b91425dd82ce49df EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel 2ef16d497bdbc2d819e57e5a5db5ffbc603e83d8 11464704 f4afe782f3e4bbc0e92c2a99b91425dd82ce49df:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
