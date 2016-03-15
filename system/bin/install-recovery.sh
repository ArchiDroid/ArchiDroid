#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 30674944 001d6c19a12512ccef83a37fa35f49df48c71fd2 27172864 760a907cc36d134cbc419cc3be2da6165b775328
fi

if ! applypatch -c EMMC:/dev/block/bootdevice/by-name/recovery:30674944:001d6c19a12512ccef83a37fa35f49df48c71fd2; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/bootdevice/by-name/boot:27172864:760a907cc36d134cbc419cc3be2da6165b775328 EMMC:/dev/block/bootdevice/by-name/recovery 001d6c19a12512ccef83a37fa35f49df48c71fd2 30674944 760a907cc36d134cbc419cc3be2da6165b775328:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
