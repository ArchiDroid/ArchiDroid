#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7987200 d9db6544196f8b9d2db54b84278405d0639a62a9 5447680 63af6961d9a63aff89cf0309cd64b54986d6004e
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7987200:d9db6544196f8b9d2db54b84278405d0639a62a9; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5447680:63af6961d9a63aff89cf0309cd64b54986d6004e EMMC:/dev/block/mmcblk0p6 d9db6544196f8b9d2db54b84278405d0639a62a9 7987200 63af6961d9a63aff89cf0309cd64b54986d6004e:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
