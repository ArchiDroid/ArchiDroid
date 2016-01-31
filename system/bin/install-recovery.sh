#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 30269440 5b59ef7404f71a493deb1ac2cde875e3146bd1ba 26996736 14bdf5d9c5ad82cfd1c8838e8daaed6fdc31c0f4
fi

if ! applypatch -c EMMC:/dev/block/bootdevice/by-name/recovery:30269440:5b59ef7404f71a493deb1ac2cde875e3146bd1ba; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/bootdevice/by-name/boot:26996736:14bdf5d9c5ad82cfd1c8838e8daaed6fdc31c0f4 EMMC:/dev/block/bootdevice/by-name/recovery 5b59ef7404f71a493deb1ac2cde875e3146bd1ba 30269440 14bdf5d9c5ad82cfd1c8838e8daaed6fdc31c0f4:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
