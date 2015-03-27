#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8921088 cfd73231812acfb971ee5348385e862f852d88f5 5701632 e842e3be9b8a31d6a3d09d7ffcdc62c267d96b08
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8921088:cfd73231812acfb971ee5348385e862f852d88f5; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5701632:e842e3be9b8a31d6a3d09d7ffcdc62c267d96b08 EMMC:/dev/block/mmcblk0p6 cfd73231812acfb971ee5348385e862f852d88f5 8921088 e842e3be9b8a31d6a3d09d7ffcdc62c267d96b08:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
