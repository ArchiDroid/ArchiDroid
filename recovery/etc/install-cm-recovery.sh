#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8228864 28c7e996ecd9aa07d4e699bdeebfd141ed38769c 5470208 274a8df445b9006adee6b7c1fab244c2b67409fc
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8228864:28c7e996ecd9aa07d4e699bdeebfd141ed38769c; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5470208:274a8df445b9006adee6b7c1fab244c2b67409fc EMMC:/dev/block/mmcblk0p6 28c7e996ecd9aa07d4e699bdeebfd141ed38769c 8228864 274a8df445b9006adee6b7c1fab244c2b67409fc:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
