#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7845888 fad595509206f3497053aed472b2f7e56e9c87ea 5087232 1e886375bd36fce5debf271fd446911a264fe19b
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7845888:fad595509206f3497053aed472b2f7e56e9c87ea; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:1e886375bd36fce5debf271fd446911a264fe19b EMMC:/dev/block/mmcblk0p6 fad595509206f3497053aed472b2f7e56e9c87ea 7845888 1e886375bd36fce5debf271fd446911a264fe19b:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
