#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8255488 92f846ed6f94f64314413c1b95e34227ddf34059 5496832 fc12a411b8e4692f309acc3c8a32a7e1cd35b375
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8255488:92f846ed6f94f64314413c1b95e34227ddf34059; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5496832:fc12a411b8e4692f309acc3c8a32a7e1cd35b375 EMMC:/dev/block/mmcblk0p6 92f846ed6f94f64314413c1b95e34227ddf34059 8255488 fc12a411b8e4692f309acc3c8a32a7e1cd35b375:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
