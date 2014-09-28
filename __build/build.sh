#!/bin/bash

#     _             _     _ ____            _     _
#    / \   _ __ ___| |__ (_)  _ \ _ __ ___ (_) __| |
#   / _ \ | '__/ __| '_ \| | | | | '__/ _ \| |/ _` |
#  / ___ \| | | (__| | | | | |_| | | | (_) | | (_| |
# /_/   \_\_|  \___|_| |_|_|____/|_|  \___/|_|\__,_|
#
# Copyright 2014 Łukasz "JustArchi" Domeradzki
# Contact: JustArchi@JustArchi.net
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

VERSION=3.0.0

# Device-based
DEVICE="BRINGUP" # This is AOSP variant to build, the one used in brunch command. If you use "brunch i9300", you should set it to i9300 here
BUILDVARIANT="user" # Change this to userdebug if for some reason you can't build with user variant

# Rom-based
ROM="CyanogenMod" # This is actually for information purpose only, can be anything
ROMSHORT="cm" # This however, MUST match the repo name at ArchiDroid/ArchiDroid, e.g. if it's i9300-omnirom-experimental, we must type "omnirom" here

# Detect HOME properly
# This workaround is required because arm-eabi-nm has problems following ~. Don't change it
if [[ "$(dirname ~)" = "/" ]]; then
	HOME="$(dirname ~)$(basename ~)" # Root
else
	HOME="$(dirname ~)/$(basename ~)" # User
fi

# Try to not change these if you can
ADROOT="$HOME/shared/git/ArchiDroid" # This is where ArchiDroid GitHub repo is located
ADZIP="$ROMSHORT-*.zip" # This is with what defined output zip. For omni it would be "omni-*.zip"
ADCOMPILEROOT="$HOME/android/cm" # This is where AOSP sources are located
ADOUT="$ADCOMPILEROOT/out/target/product/$DEVICE" # This is the location of output zip from above sources, usually it doesn't need to be changed

# Common
PREBUILT=0
STABLE=0
STOCK=0
OLD=0

export USE_CCACHE=1

cd "$(dirname "$0")"

for ARG in "$@" ; do
	case "$ARG" in
		--prebuilt|prebuilt)
			PREBUILT=1
			echo "WARNING: Assuming that build is already complete!"
			;;
		--stable|stable)
			STABLE=1
			echo "WARNING: Building stable release!"
			;;
		--stock|stock)
			STOCK=1
			PREBUILT=1
			echo "WARNING: Assuming that this is stock firmware!"
			;;
		--old|old)
			OLD=1
			echo "WARNING: Not doing repo sync!"
			;;
	esac
done
sleep 1

if [[ "$PREBUILT" -eq 0 ]]; then
	cd "$ADCOMPILEROOT"
	if [[ "$OLD" -eq 0 ]]; then
		repo selfupdate
		repo sync -j32
	fi

	if [[ -d "$ADOUT" ]]; then
		find "$ADOUT" -mindepth 1 -maxdepth 1 -name "$ADZIP" | while read ZIP; do
			echo "WARNING: Removing old zip: $ZIP"
			rm -f "$ZIP"
		done
	fi

	source build/envsetup.sh
	brunch "$DEVICE" "$BUILDVARIANT" || true

	REALADZIP=""
	while read ZIP; do
		REALADZIP="$ZIP"
		break
	done < <(find "$ADOUT" -mindepth 1 -maxdepth 1 -type f -name "$ADZIP")

	if [[ -z "$REALADZIP" ]]; then
		echo "ERROR: It looks like build didn't succeed!"
		exit 1
	else
		echo "INFO: Build succeeded!"
	fi

	ADZIP="$(basename "$REALADZIP")"
	cp "$REALADZIP" "$ADROOT"
else
	while read ZIP; do
		REALADZIP="$ZIP"
		break
	done < <(find "$ADROOT" -mindepth 1 -maxdepth 1 -type f -name "$ADZIP")

	if [[ -z "$REALADZIP" ]]; then
		echo "ERROR: It looks like there's no $ADZIP available in $ADROOT!"
		exit 1
	fi

	ADZIP="$(basename "$REALADZIP")"
fi

cd "$ADROOT"

rm -rf system recovery
mv META-INF/com/google/android/updater-script META-INF/com/google/android/updater-script.old
mv META-INF/com/google/android/update-binary META-INF/com/google/android/update-binary.old
unzip -o "$ADZIP"
rm -f "$ADZIP"

NEWMD5="$(md5sum META-INF/com/google/android/updater-script | awk '{print $1}')"
if [[ -f "__build/_updater-scripts/archidroid/updater-script" ]]; then
	OLDMD5="$(md5sum __build/_updater-scripts/archidroid/updater-script | awk '{print $1}')"
else
	OLDMD5="$NEWMD5"
fi

if [[ "$OLDMD5" != "$NEWMD5" ]]; then
	echo "WARNING: Updater-script got some new additions!"
	echo "Probably just symlink or permissions stuff"
	echo "For keeping maximum compatibility, YOU must merge these changes"
	echo "Here are the changes:"
	echo "---"
	diff __build/_updater-scripts/archidroid/updater-script META-INF/com/google/android/updater-script || true
	echo "---"
	echo "This comparision has been made with diff tool of old and new updater-script"
	echo "Old updater-script: __build/_updater-scripts/archidroid/updater-script"
	echo "New updater-script: META-INF/com/google/android/updater-script"
	echo "ArchiDroid's updater-script: META-INF/com/google/android/updater-script.old"
	echo "Please merge changes above to ArchiDroid's updater script BEFORE you continue"
	read -p "Press [Enter] key to continue..."
	cp META-INF/com/google/android/updater-script __build/_updater-scripts/archidroid/updater-script
	echo "NOTICE: New updater-script has replaced old updater-script in future comparisions!"
	echo "You'll be informed in case of future additions to updater-script"
elif [[ ! -f "__build/_updater-scripts/archidroid/updater-script" ]]; then
	mkdir -p __build/_updater-scripts/archidroid
	cp META-INF/com/google/android/updater-script __build/_updater-scripts/archidroid/updater-script
	echo "WARNING: This is your FIRST build for unsupported device"
	echo "Congratulations for going THAT far!"
	echo "Don't forget to add permissions and symlinks to ArchiDroid's updater-script"
	echo "Search for 'BRINGUP' word in META-INF/com/google/android/updater-script"
	echo "Original updater-script from the ROM is located in __build/_updater-scripts/archidroid/updater-script"
	echo "This file will be automatically used for any comparisions in future"
	echo "This means that you don't need to keep an eye on any updater-script changes, this script will keep you informed"
else
	echo "INFO: Updater-scripts are the same! You don't need to merge any conflicts!"
fi

# Fix everything
mv META-INF/com/google/android/update-binary META-INF/com/google/android/update-binary-installer # New update-binary -> update-binary-installer
mv META-INF/com/google/android/update-binary.old META-INF/com/google/android/update-binary # Aroma -> update-binary
mv META-INF/com/google/android/updater-script.old META-INF/com/google/android/updater-script # ArchiDroid updater-script -> updater-script

cd __build

if [[ "$STOCK" -eq 1 ]]; then
	AVERSION="$(grep "ro.build.version.incremental" "../system/build.prop" | cut -d '=' -f 2)"
else
	AVERSION="$(grep "ro.build.id" "../system/build.prop" | cut -d '=' -f 2)"
fi
if [[ "$STABLE" -eq 1 ]]; then
	TVERSION="STABLE"
else
	TVERSION="EXPERIMENTAL"
fi

if [[ "$STOCK" -eq 1 ]]; then
	if [[ -d framework-res ]]; then
		(
			cd framework-res || exit
			zip -0 -r ../../system/framework/framework-res.apk ./*
			cd ..
			chmod 755 utilities/zipalign
			./utilities/zipalign -v -f 4 ../system/framework/framework-res.apk TEMP.apk
			mv TEMP.apk ../system/framework/framework-res.apk
		)
	fi

	# Handle everything what we may have already
	# Superuser, we have selection of superusers so we really don't want anyone
	rm -f ../system/app/Superuser.apk ../system/app/Superuser.odex ../system/xbin/su ../system/xbin/daemonsu ../system/etc/init.d/99SuperSUDaemon ../system/etc/install-recovery.sh ../system/etc/.installed_su_daemon
	rm -rf ../system/bin/.ext

	# Busybox, we may want this one
	if [[ -f ../system/xbin/busybox ]]; then
		mkdir -p ../_archidroid/auto/system/xbin
		mv ../system/xbin/busybox ../_archidroid/auto/system/xbin
	fi

	# ArchiDroid's Init.d
	if [[ -f ../system/bin/debuggerd.real ]]; then
		mkdir -p ../_archidroid/auto/system/bin
		mv ../system/bin/debuggerd ../_archidroid/auto/system/bin/addebuggerd # TODO: Fix addebuggerd
	fi

	# TODO: Make sure that this works
	if [[ -d ../bloatware ]]; then
		mkdir -p _bloatware/bloatware
		mv ../bloatware/* _bloatware/bloatware
		rm -rf ../bloatware
	fi
fi


### Handle build.prop ###
echo "# ArchiDroid build.prop" > build.prop.TEMP
{
	echo "ro.archidroid=1"
	echo "ro.archidroid.device=$DEVICE"
	echo "ro.archidroid.rom=$ROM"
	echo "ro.archidroid.rom.short=$ROMSHORT"
	echo "ro.archidroid.version=$VERSION"
	echo "ro.archidroid.version.android=$AVERSION"
	echo "ro.archidroid.version.type=$TVERSION"
	echo
	cat ../system/build.prop
} >> build.prop.TEMP

# Change default version to our custom one
sed -i "/ro.build.display.id=/c\ro.build.display.id=ArchiDroid-$VERSION-$TVERSION-$AVERSION-$ROM-$DEVICE" build.prop.TEMP
mv build.prop.TEMP ../system/build.prop

exit 0
