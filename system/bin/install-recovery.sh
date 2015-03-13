#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7964672 f341a7fa2e08da96893d2d779d59097708122b68 5445632 eddefcef8d7703a0f2507e8dca85bf83824e3ff7
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7964672:f341a7fa2e08da96893d2d779d59097708122b68; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5445632:eddefcef8d7703a0f2507e8dca85bf83824e3ff7 EMMC:/dev/block/mmcblk0p6 f341a7fa2e08da96893d2d779d59097708122b68 7964672 eddefcef8d7703a0f2507e8dca85bf83824e3ff7:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
