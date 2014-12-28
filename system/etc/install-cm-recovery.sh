#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 10014720 13035dc0d0bc3c1495b82810beba1255aece565d 11370496 5fc1c57b5215df491e0e524bbad436c0f3bb916f
fi

if ! applypatch -c EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel:10014720:13035dc0d0bc3c1495b82810beba1255aece565d; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/platform/msm_sdcc.1/by-name/boot:11370496:5fc1c57b5215df491e0e524bbad436c0f3bb916f EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel 13035dc0d0bc3c1495b82810beba1255aece565d 10014720 5fc1c57b5215df491e0e524bbad436c0f3bb916f:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
