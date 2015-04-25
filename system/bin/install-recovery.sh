#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9375744 2f2588d94b5774480ad84d89983f665f0350f8e9 6141952 d5fb4c522ca61a7d8cdeffe25bb7209f7e32fa5b
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9375744:2f2588d94b5774480ad84d89983f665f0350f8e9; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6141952:d5fb4c522ca61a7d8cdeffe25bb7209f7e32fa5b EMMC:/dev/block/mmcblk0p6 2f2588d94b5774480ad84d89983f665f0350f8e9 9375744 d5fb4c522ca61a7d8cdeffe25bb7209f7e32fa5b:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
