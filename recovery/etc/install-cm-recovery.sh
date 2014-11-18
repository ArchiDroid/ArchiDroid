#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7845888 c7fd7f76be036844665aea0e10f08b4f98b6e530 5087232 4db22aa1aa62602be4f766b2feb76f4bff83e501
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7845888:c7fd7f76be036844665aea0e10f08b4f98b6e530; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:4db22aa1aa62602be4f766b2feb76f4bff83e501 EMMC:/dev/block/mmcblk0p6 c7fd7f76be036844665aea0e10f08b4f98b6e530 7845888 4db22aa1aa62602be4f766b2feb76f4bff83e501:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
