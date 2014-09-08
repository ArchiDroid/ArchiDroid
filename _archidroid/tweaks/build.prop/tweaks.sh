#!/sbin/sh
echo "
############################
### ArchiDroid build.prop Tweaks ###

# Turn on Navigation Bar
#qemu.hw.mainkeys=0

# Allow purging of assets
# CyanogenMod Only
persist.sys.purgeable_assets=1

### ArchiDroid build.prop Tweaks ###
############################
" >> /system/build.prop

exit 0
