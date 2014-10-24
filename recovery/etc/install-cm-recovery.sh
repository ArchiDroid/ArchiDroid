#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7845888 41157b54e5e676e14a595039683c655e3a59e6a0 5087232 584fb67f8b5c3e6e407827ae1ba47c69d6b9c6e1
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7845888:41157b54e5e676e14a595039683c655e3a59e6a0; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:584fb67f8b5c3e6e407827ae1ba47c69d6b9c6e1 EMMC:/dev/block/mmcblk0p6 41157b54e5e676e14a595039683c655e3a59e6a0 7845888 584fb67f8b5c3e6e407827ae1ba47c69d6b9c6e1:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
