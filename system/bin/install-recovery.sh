#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7987200 c274634012a9b60517d5e3d50eb084a5ad9eb25a 5447680 e9c0d55fd7ca1e57cacb6f9dd8152ff7bbb5114e
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7987200:c274634012a9b60517d5e3d50eb084a5ad9eb25a; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5447680:e9c0d55fd7ca1e57cacb6f9dd8152ff7bbb5114e EMMC:/dev/block/mmcblk0p6 c274634012a9b60517d5e3d50eb084a5ad9eb25a 7987200 e9c0d55fd7ca1e57cacb6f9dd8152ff7bbb5114e:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
