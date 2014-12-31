#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8255488 4c49265b5345f38b09de0b989851620f64e3ca7b 5496832 c918a9d46a0d9766ac88dfe7db8bcf50b80177b0
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8255488:4c49265b5345f38b09de0b989851620f64e3ca7b; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5496832:c918a9d46a0d9766ac88dfe7db8bcf50b80177b0 EMMC:/dev/block/mmcblk0p6 4c49265b5345f38b09de0b989851620f64e3ca7b 8255488 c918a9d46a0d9766ac88dfe7db8bcf50b80177b0:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
