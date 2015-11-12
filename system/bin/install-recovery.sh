#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 10434560 bffe1fa16c57fcaccedfec1cc9782f57866b57d6 6131712 e72ec0895dc5a39a3464cbf19420cc4ce27bc430
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:10434560:bffe1fa16c57fcaccedfec1cc9782f57866b57d6; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6131712:e72ec0895dc5a39a3464cbf19420cc4ce27bc430 EMMC:/dev/block/mmcblk0p6 bffe1fa16c57fcaccedfec1cc9782f57866b57d6 10434560 e72ec0895dc5a39a3464cbf19420cc4ce27bc430:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
