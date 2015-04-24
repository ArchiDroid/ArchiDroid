#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9375744 0fbe79b86d99bc86418632add3778ca55695443a 6141952 cb8a1703062c39c9f0bd843b417b3c77762a449b
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9375744:0fbe79b86d99bc86418632add3778ca55695443a; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6141952:cb8a1703062c39c9f0bd843b417b3c77762a449b EMMC:/dev/block/mmcblk0p6 0fbe79b86d99bc86418632add3778ca55695443a 9375744 cb8a1703062c39c9f0bd843b417b3c77762a449b:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
