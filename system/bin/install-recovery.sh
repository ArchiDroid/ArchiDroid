#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9381888 df7363cd1cce15d82e8c901d27ef94cad21c9ffc 6150144 1fbb5f7b995b10c9d58611fa0a61c7ba8769d289
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9381888:df7363cd1cce15d82e8c901d27ef94cad21c9ffc; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6150144:1fbb5f7b995b10c9d58611fa0a61c7ba8769d289 EMMC:/dev/block/mmcblk0p6 df7363cd1cce15d82e8c901d27ef94cad21c9ffc 9381888 1fbb5f7b995b10c9d58611fa0a61c7ba8769d289:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
