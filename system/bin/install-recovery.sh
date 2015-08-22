#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9635840 8e07515b716debbf2e820a6c6149cbecf137fd94 6260736 f992f58edefa5a36fdb58ed85b357020607a772b
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:9635840:8e07515b716debbf2e820a6c6149cbecf137fd94; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:6260736:f992f58edefa5a36fdb58ed85b357020607a772b EMMC:/dev/block/mmcblk0p6 8e07515b716debbf2e820a6c6149cbecf137fd94 9635840 f992f58edefa5a36fdb58ed85b357020607a772b:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
