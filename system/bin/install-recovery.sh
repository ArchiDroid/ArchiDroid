#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9596928 f58de9527b0df2d31d63c98c312c9a71da681cff 6240256 8d31c60da7698db0ded3cd69a066110a17fb7e23
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9596928:f58de9527b0df2d31d63c98c312c9a71da681cff; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6240256:8d31c60da7698db0ded3cd69a066110a17fb7e23 EMMC:/dev/block/mmcblk0p6 f58de9527b0df2d31d63c98c312c9a71da681cff 9596928 8d31c60da7698db0ded3cd69a066110a17fb7e23:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
