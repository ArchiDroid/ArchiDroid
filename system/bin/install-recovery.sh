#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 30392320 11c6f585e3fda6bfa818139730163b84a1ac2b00 26906624 74c0a6b217db00a484ba96b20255a20b24494a54
fi

if ! applypatch -c EMMC:/dev/block/bootdevice/by-name/recovery:30392320:11c6f585e3fda6bfa818139730163b84a1ac2b00; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/bootdevice/by-name/boot:26906624:74c0a6b217db00a484ba96b20255a20b24494a54 EMMC:/dev/block/bootdevice/by-name/recovery 11c6f585e3fda6bfa818139730163b84a1ac2b00 30392320 74c0a6b217db00a484ba96b20255a20b24494a54:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
