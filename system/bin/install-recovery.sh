#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 30601216 f862c6becbfa917a46d05030b3f06b4df783ddc6 27119616 ef92b61342b904f4612bf4edefd9342dcb49a745
fi

if ! applypatch -c EMMC:/dev/block/bootdevice/by-name/recovery:30601216:f862c6becbfa917a46d05030b3f06b4df783ddc6; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/bootdevice/by-name/boot:27119616:ef92b61342b904f4612bf4edefd9342dcb49a745 EMMC:/dev/block/bootdevice/by-name/recovery f862c6becbfa917a46d05030b3f06b4df783ddc6 30601216 ef92b61342b904f4612bf4edefd9342dcb49a745:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
