#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8015872 ebdc155e60affe13459d245dde2750f5b8292669 5103616 b2a4c70087d342ad1f270cb985df88f4ba654c54
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8015872:ebdc155e60affe13459d245dde2750f5b8292669; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5103616:b2a4c70087d342ad1f270cb985df88f4ba654c54 EMMC:/dev/block/mmcblk0p6 ebdc155e60affe13459d245dde2750f5b8292669 8015872 b2a4c70087d342ad1f270cb985df88f4ba654c54:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
