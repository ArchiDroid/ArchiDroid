#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7960576 f0a93de27482e6b3a2e9dbc0d1058966412acb5c 5439488 3a564e8a9c55ef48dd9e90cdf86813103a509fb9
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7960576:f0a93de27482e6b3a2e9dbc0d1058966412acb5c; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5439488:3a564e8a9c55ef48dd9e90cdf86813103a509fb9 EMMC:/dev/block/mmcblk0p6 f0a93de27482e6b3a2e9dbc0d1058966412acb5c 7960576 3a564e8a9c55ef48dd9e90cdf86813103a509fb9:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
