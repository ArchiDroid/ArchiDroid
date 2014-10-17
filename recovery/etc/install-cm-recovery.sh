#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7845888 7560775ac5151ce049601a49232372d67ff23e05 5087232 f86dd08ca70ab202aeba248900a6302a42182ab6
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7845888:7560775ac5151ce049601a49232372d67ff23e05; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:f86dd08ca70ab202aeba248900a6302a42182ab6 EMMC:/dev/block/mmcblk0p6 7560775ac5151ce049601a49232372d67ff23e05 7845888 f86dd08ca70ab202aeba248900a6302a42182ab6:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
