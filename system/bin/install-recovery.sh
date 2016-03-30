#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 30658560 29d42c7e553d8cc6035903a3c7225c5ddd85352e 27156480 6a20bdc25f4f040ce709965edaac2a5b8154c829
fi

if ! applypatch -c EMMC:/dev/block/bootdevice/by-name/recovery:30658560:29d42c7e553d8cc6035903a3c7225c5ddd85352e; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/bootdevice/by-name/boot:27156480:6a20bdc25f4f040ce709965edaac2a5b8154c829 EMMC:/dev/block/bootdevice/by-name/recovery 29d42c7e553d8cc6035903a3c7225c5ddd85352e 30658560 6a20bdc25f4f040ce709965edaac2a5b8154c829:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
