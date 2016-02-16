#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 30633984 879149379ae50fe7735e014ec2960d001eb89f98 27148288 aa68a2d0a0f784f7352297a38601c20090e8f4b3
fi

if ! applypatch -c EMMC:/dev/block/bootdevice/by-name/recovery:30633984:879149379ae50fe7735e014ec2960d001eb89f98; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/bootdevice/by-name/boot:27148288:aa68a2d0a0f784f7352297a38601c20090e8f4b3 EMMC:/dev/block/bootdevice/by-name/recovery 879149379ae50fe7735e014ec2960d001eb89f98 30633984 aa68a2d0a0f784f7352297a38601c20090e8f4b3:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
