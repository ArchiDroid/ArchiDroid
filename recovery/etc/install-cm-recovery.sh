#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8255488 aabe99593c6e05c184d230e7c537271f76e9d8ba 5496832 f351326e571766e4d04c6de60fc97d8113f13670
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8255488:aabe99593c6e05c184d230e7c537271f76e9d8ba; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5496832:f351326e571766e4d04c6de60fc97d8113f13670 EMMC:/dev/block/mmcblk0p6 aabe99593c6e05c184d230e7c537271f76e9d8ba 8255488 f351326e571766e4d04c6de60fc97d8113f13670:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
