#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8976384 bb561b2a220fbaeb03b516954b4b14f344b7476f 6051840 7d3b8dd213b3fbce65a565a32c4376a539ca2cc1
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8976384:bb561b2a220fbaeb03b516954b4b14f344b7476f; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6051840:7d3b8dd213b3fbce65a565a32c4376a539ca2cc1 EMMC:/dev/block/mmcblk0p6 bb561b2a220fbaeb03b516954b4b14f344b7476f 8976384 7d3b8dd213b3fbce65a565a32c4376a539ca2cc1:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
