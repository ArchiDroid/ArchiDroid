#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8916992 e81843a87e9d99bcfe78812261308ac16f724f62 5697536 06d8d9c831200100914c78d0f878e84144e94d77
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8916992:e81843a87e9d99bcfe78812261308ac16f724f62; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5697536:06d8d9c831200100914c78d0f878e84144e94d77 EMMC:/dev/block/mmcblk0p6 e81843a87e9d99bcfe78812261308ac16f724f62 8916992 06d8d9c831200100914c78d0f878e84144e94d77:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
