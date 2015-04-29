#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 11464704 6e3c66b35336c5540143879f82274a857614f52a 13348864 8d0487569a430d46ac04db2bdd887a49f8d816b5
fi

if ! applypatch -c EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel:11464704:6e3c66b35336c5540143879f82274a857614f52a; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/platform/msm_sdcc.1/by-name/boot:13348864:8d0487569a430d46ac04db2bdd887a49f8d816b5 EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel 6e3c66b35336c5540143879f82274a857614f52a 11464704 8d0487569a430d46ac04db2bdd887a49f8d816b5:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
