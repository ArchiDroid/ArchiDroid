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

VERSION=2.5.4

# Device-based
ADVARIANT="i9300" # This is AOSP variant to build, the one used in brunch command. If you use "brunch i9300", you should set it to i9300 here
BUILDVARIANT="user" # Change this to userdebug if for some reason you can't build with user variant

# Detect HOME properly
# This workaround is required because arm-eabi-nm has problems following ~. Don't change it
if [[ "$(dirname ~)" = "/" ]]; then
	HOME="$(dirname ~)$(basename ~)" # Root
else
	HOME="$(dirname ~)/$(basename ~)" # User
fi

# Try to not change these if you can
ADROOT="$HOME/shared/git/ArchiDroid" # This is where ArchiDroid GitHub repo is located
ADZIP="cm-*.zip" # This is with what defined output zip. For omni it would be "omni-*.zip"
ADCOMPILEROOT="$HOME/android/cm" # This is where AOSP sources are located
ADOUT="$ADCOMPILEROOT/out/target/product/$ADVARIANT" # This is the location of output zip from above sources, usually it doesn't need to be changed

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

OTA="echo \"updateme.version=$VERSION\" >> /system/build.prop"
if [[ "$STABLE" -eq 0 ]]; then
	VERSION="$VERSION EXPERIMENTAL"
else
	VERSION="$VERSION STABLE"
fi

if [[ "$PREBUILT" -eq 0 ]]; then
	cd "$ADCOMPILEROOT"
	if [[ "$OLD" -eq 0 ]]; then
		repo selfupdate
		repo sync -j32
	fi

	if [[ -d "$ADOUT" ]]; then
		find "$ADOUT" -mindepth 1 -maxdepth 1 -name "*.zip" | while read ZIP; do
			echo "WARNING: Removing old zip: $ZIP"
			rm -f "$ZIP"
		done
	fi

	source build/envsetup.sh
	brunch "$ADVARIANT" "$BUILDVARIANT" || true

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
fi

cd "$ADROOT"

rm -rf system recovery
mv META-INF/com/google/android/updater-script META-INF/com/google/android/updater-script.old
mv META-INF/com/google/android/update-binary META-INF/com/google/android/update-binary.old
unzip "$ADZIP"
rm -f "$ADZIP"

NEWMD5="$(md5sum META-INF/com/google/android/updater-script | awk '{print $1}')"
if [[ -f "__build/_updater-scripts/archidroid/updater-script" ]]; then
	OLDMD5="$(md5sum __build/_updater-scripts/archidroid/updater-script | awk '{print $1}')"
else
	OLDMD5="$NEWMD5"
fi

if [[ "$OLD" != "$NEW" ]]; then
	echo "Warning! Updater-script got some new additions!"
	echo "Probably just symlink or permissions stuff"
	diff __build/_updater-scripts/archidroid/updater-script META-INF/com/google/android/updater-script || true
	mkdir -p __build/_updater-scripts/archidroid
	cp META-INF/com/google/android/updater-script __build/_updater-scripts/archidroid/updater-script
	echo "Please merge changes with your original updater-script!"
else
	echo "Updater-scripts are the same!"
fi

# Fix everything
mv META-INF/com/google/android/update-binary META-INF/com/google/android/update-binary-installer # New update-binary -> update-binary-installer
mv META-INF/com/google/android/update-binary.old META-INF/com/google/android/update-binary # Aroma -> update-binary
mv META-INF/com/google/android/updater-script.old META-INF/com/google/android/updater-script # ArchiDroid updater-script -> updater-script

cd __build

VERSION+=' ['
if [[ "$STOCK" -eq 1 ]]; then
	VERSION+="$(grep "ro.build.version.incremental" "../system/build.prop" | cut -d '=' -f 2)"
else
	VERSION+="$(grep "ro.build.id" "../system/build.prop" | cut -d '=' -f 2)"
fi
VERSION+=']'

if [[ "$STOCK" -eq 1 ]]; then
	if [[ -d framework-res ]]; then
		cd framework-res
		zip -0 -r ../../system/framework/framework-res.apk *
		cd ..
		chmod 755 utilities/zipalign
		./utilities/zipalign -v -f 4 ../system/framework/framework-res.apk TEMP.apk
		mv TEMP.apk ../system/framework/framework-res.apk
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



### STUFF BELOW REALLY NEEDS REWRITE SOONER OR LATER

##################
### OTA UPDATE ###
FILE=otaold.sh
FILEO=ota.sh
cp ../_archidroid/ota/ota.sh $FILE
GDZIE=`grep -n "updateme.version=" $FILE | cut -f1 -d:`
ILE=`cat $FILE | wc -l`
ILE=`expr $ILE - $GDZIE`
GDZIE=`expr $GDZIE - 1`
cat $FILE | head -${GDZIE} > $FILEO
echo $OTA >> $FILEO
ILE=`expr $ILE + 1`
cat $FILE | tail -${ILE} >> $FILEO
cp $FILEO $FILE
rm $FILEO
cp $FILE ../_archidroid/ota/ota.sh
rm $FILE
### OTA UPDATE ###
##################

#########################
### BUILD.PROP UPDATE ###
FILE=buildold.prop
FILEO=build.prop
cp ../system/build.prop $FILE

echo "# ArchiDroid build.prop" >> $FILEO
cat $FILE >> $FILEO
cp $FILEO $FILE
rm $FILEO

if [ $STOCK -eq 1 ]; then
	sed -i 's/S_Over_the_horizon.ogg/09_Underwater_world.ogg/g' $FILE
	sed -i 's/S_Whistle.ogg/S_Good_News.ogg/g' $FILE
	sed -i 's/Walk_in_the_forest.ogg/Dawn_chorus.ogg/g' $FILE
fi

GDZIE=`grep -n "ro.build.display.id=" $FILE | cut -f1 -d:`
ILE=`cat $FILE | wc -l`
ILE=`expr $ILE - $GDZIE`
GDZIE=`expr $GDZIE - 1`
cat $FILE | head -${GDZIE} > $FILEO
echo "ro.build.display.id=ArchiDroid $VERSION" >> $FILEO
echo "ro.archidroid.version=$VERSION" >> $FILEO
cat $FILE | tail -${ILE} >> $FILEO
cp $FILEO $FILE
rm $FILEO

cp $FILE ../system/build.prop
rm $FILE

### BUILD.PROP UPDATE ###
#########################

#################
### BLOATWARE ###
#rm -f ../system/app/CMUpdater.apk
### BLOATWARE ###
#################

exit 0

