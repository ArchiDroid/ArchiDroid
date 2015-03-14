#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8916992 453428d1a2930ddd59c3dae376fe769712536f51 5697536 fe411dfc80b47fa9d73e3d32e3042137e850ddc9
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8916992:453428d1a2930ddd59c3dae376fe769712536f51; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5697536:fe411dfc80b47fa9d73e3d32e3042137e850ddc9 EMMC:/dev/block/mmcblk0p6 453428d1a2930ddd59c3dae376fe769712536f51 8916992 fe411dfc80b47fa9d73e3d32e3042137e850ddc9:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
