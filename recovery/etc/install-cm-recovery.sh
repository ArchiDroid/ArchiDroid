#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7993344 4e2444964e381aa7823812a7a49f33a523c6a054 5087232 022986cb70001d734ed6f18225297f345e324350
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7993344:4e2444964e381aa7823812a7a49f33a523c6a054; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:022986cb70001d734ed6f18225297f345e324350 EMMC:/dev/block/mmcblk0p6 4e2444964e381aa7823812a7a49f33a523c6a054 7993344 022986cb70001d734ed6f18225297f345e324350:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
