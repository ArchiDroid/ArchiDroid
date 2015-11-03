#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 10438656 0399e8dd94b1b65e2850281b2abfa4159f162537 6131712 feefca888a57f69284a6b41edc8df49e009b7e83
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:10438656:0399e8dd94b1b65e2850281b2abfa4159f162537; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6131712:feefca888a57f69284a6b41edc8df49e009b7e83 EMMC:/dev/block/mmcblk0p6 0399e8dd94b1b65e2850281b2abfa4159f162537 10438656 feefca888a57f69284a6b41edc8df49e009b7e83:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
