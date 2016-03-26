#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 30658560 27c33f043b40040361cfa9ad2ba944839d2dd92f 27156480 04fe56dc59a3b80adcc80b82539ca8b37efbc398
fi

if ! applypatch -c EMMC:/dev/block/bootdevice/by-name/recovery:30658560:27c33f043b40040361cfa9ad2ba944839d2dd92f; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/bootdevice/by-name/boot:27156480:04fe56dc59a3b80adcc80b82539ca8b37efbc398 EMMC:/dev/block/bootdevice/by-name/recovery 27c33f043b40040361cfa9ad2ba944839d2dd92f 30658560 04fe56dc59a3b80adcc80b82539ca8b37efbc398:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
