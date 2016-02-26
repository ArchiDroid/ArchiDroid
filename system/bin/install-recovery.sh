#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 30457856 71bdc733a8437be57bb760dfafbc5c4a48b229e0 26972160 a48563168e0bd8947f18af5c3cd510e83a7b344b
fi

if ! applypatch -c EMMC:/dev/block/bootdevice/by-name/recovery:30457856:71bdc733a8437be57bb760dfafbc5c4a48b229e0; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/bootdevice/by-name/boot:26972160:a48563168e0bd8947f18af5c3cd510e83a7b344b EMMC:/dev/block/bootdevice/by-name/recovery 71bdc733a8437be57bb760dfafbc5c4a48b229e0 30457856 a48563168e0bd8947f18af5c3cd510e83a7b344b:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
