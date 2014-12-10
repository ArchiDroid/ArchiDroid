#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7845888 08e44c23c11e29f7d960688960dab5690a80e941 5087232 c94e7df5f1f1d51edff161d0824d33eae9102ed5
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7845888:08e44c23c11e29f7d960688960dab5690a80e941; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:c94e7df5f1f1d51edff161d0824d33eae9102ed5 EMMC:/dev/block/mmcblk0p6 08e44c23c11e29f7d960688960dab5690a80e941 7845888 c94e7df5f1f1d51edff161d0824d33eae9102ed5:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
