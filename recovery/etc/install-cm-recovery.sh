#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7845888 4eb34701488b4c607c5895619e24eb1c48a8c8f6 5087232 ca7336c76c5716338fc095399ece0286ad8524bf
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7845888:4eb34701488b4c607c5895619e24eb1c48a8c8f6; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:ca7336c76c5716338fc095399ece0286ad8524bf EMMC:/dev/block/mmcblk0p6 4eb34701488b4c607c5895619e24eb1c48a8c8f6 7845888 ca7336c76c5716338fc095399ece0286ad8524bf:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
