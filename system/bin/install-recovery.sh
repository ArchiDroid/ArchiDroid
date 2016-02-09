#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 30633984 ea19a068a10c840172567aa88de5d5f6ad9bb472 27144192 5f4a4219bcdf256e284229c864a7c887e82ef920
fi

if ! applypatch -c EMMC:/dev/block/bootdevice/by-name/recovery:30633984:ea19a068a10c840172567aa88de5d5f6ad9bb472; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/bootdevice/by-name/boot:27144192:5f4a4219bcdf256e284229c864a7c887e82ef920 EMMC:/dev/block/bootdevice/by-name/recovery ea19a068a10c840172567aa88de5d5f6ad9bb472 30633984 5f4a4219bcdf256e284229c864a7c887e82ef920:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
