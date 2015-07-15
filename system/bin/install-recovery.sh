#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9619456 1aaa7a2f5e778eda0f7f0975eba624ef2150a1ab 6244352 98341c256fff390af4497e8800d856244b6e2ee5
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9619456:1aaa7a2f5e778eda0f7f0975eba624ef2150a1ab; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6244352:98341c256fff390af4497e8800d856244b6e2ee5 EMMC:/dev/block/mmcblk0p6 1aaa7a2f5e778eda0f7f0975eba624ef2150a1ab 9619456 98341c256fff390af4497e8800d856244b6e2ee5:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
