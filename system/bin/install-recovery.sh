#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 11776000 0bc67796ac8fb3bddacdb34eac973f6c68419b49 13811712 88a5a9df22ee222211106fefaca1819c2426b4b3
fi

if ! applypatch -c EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel:11776000:0bc67796ac8fb3bddacdb34eac973f6c68419b49; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/platform/msm_sdcc.1/by-name/boot:13811712:88a5a9df22ee222211106fefaca1819c2426b4b3 EMMC:/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel 0bc67796ac8fb3bddacdb34eac973f6c68419b49 11776000 88a5a9df22ee222211106fefaca1819c2426b4b3:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
