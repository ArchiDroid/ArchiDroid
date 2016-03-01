#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 30621696 2a6042d2650b921dd6ac9ef4611f1c915e6d2a2c 27136000 15fb50fa455ed3710468cd48bcef9d92915bb76e
fi

if ! applypatch -c EMMC:/dev/block/bootdevice/by-name/recovery:30621696:2a6042d2650b921dd6ac9ef4611f1c915e6d2a2c; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/bootdevice/by-name/boot:27136000:15fb50fa455ed3710468cd48bcef9d92915bb76e EMMC:/dev/block/bootdevice/by-name/recovery 2a6042d2650b921dd6ac9ef4611f1c915e6d2a2c 30621696 15fb50fa455ed3710468cd48bcef9d92915bb76e:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
