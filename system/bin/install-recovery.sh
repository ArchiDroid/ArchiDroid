#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 30670848 3e29439e51660a81dd8ce0063301fb2c96257c9e 27172864 779717fa09cf54f9a623325e859ff9bcd54c0265
fi

if ! applypatch -c EMMC:/dev/block/bootdevice/by-name/recovery:30670848:3e29439e51660a81dd8ce0063301fb2c96257c9e; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/bootdevice/by-name/boot:27172864:779717fa09cf54f9a623325e859ff9bcd54c0265 EMMC:/dev/block/bootdevice/by-name/recovery 3e29439e51660a81dd8ce0063301fb2c96257c9e 30670848 779717fa09cf54f9a623325e859ff9bcd54c0265:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
