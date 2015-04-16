#!/sbin/sh

#     _             _     _ _  __                    _
#    / \   _ __ ___| |__ (_) |/ /___ _ __ _ __   ___| |
#   / _ \ | '__/ __| '_ \| | ' // _ \ '__| '_ \ / _ \ |
#  / ___ \| | | (__| | | | | . \  __/ |  | | | |  __/ |
# /_/   \_\_|  \___|_| |_|_|_|\_\___|_|  |_| |_|\___|_|
#
# Copyright 2014-2015 Łukasz "JustArchi" Domeradzki
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

# Device-specific
KERNEL="/dev/block/mmcblk0p5" # THIS IS FOR GALAXY S3 ONLY
PARSERAMDISK=1 # If we don't need to worry about compressed ramdisk (i.e. putting modules inside), we can skip it

# Global
AK="/tmp/archikernel"
AKDROP="$AK/drop"

exec 1>"$AK/ArchiKernel.log"
exec 2>&1

date
echo "INFO: ArchiKernel flasher ready!"
echo "INFO: Safety check: ON, flasher will immediately terminate in case of ANY error"

if [[ ! -f "$AK/mkbootimg-static" || ! -f "$AK/unpackbootimg-static" ]]; then
	echo "ERROR: No bootimg tools?!"
	exit 1
else
	chmod 755 "$AK/mkbootimg-static" "$AK/unpackbootimg-static"
fi

echo "INFO: Pulling boot.img from $KERNEL"
if which dump_image >/dev/null; then
	dump_image "$KERNEL" "$AK/boot.img"
else
	dd if="$KERNEL" of="$AK/boot.img"
fi

mkdir -p "$AKDROP/ramdisk"
echo "INFO: Unpacking pulled boot.img"
"$AK/unpackbootimg-static" -i "$AK/boot.img" -o "$AKDROP"
if [[ -f "$AKDROP/boot.img-ramdisk.gz" ]]; then
	echo "INFO: Ramdisk found!"
	if [[ "$PARSERAMDISK" -eq 1 ]]; then
		cd "$AKDROP/ramdisk"

		echo "INFO: Detecting ramdisk format..."
		CBIN="gzip -9" # We use gzip as final compression in every scenario

		if gunzip -t ../boot.img-ramdisk.gz >/dev/null 2>&1; then
			echo "INFO: GZIP format detected"
			#CBIN="gzip -9"
			DBIN="gunzip -c"
		elif lzop -t ../boot.img-ramdisk.gz >/dev/null 2>&1; then
			echo "INFO: LZO format detected"
			#CBIN="lzop -9"
			DBIN="lzop -dc"
		elif xz -t ../boot.img-ramdisk.gz >/dev/null 2>&1; then
			echo "INFO: XZ format detected"
			#CBIN="xz -9"
			DBIN="xz -dc"
		elif lzma -t ../boot.img-ramdisk.gz >/dev/null 2>&1; then
			echo "INFO: LZMA format detected"
			#CBIN="lzma -9"
			DBIN="lzma -dc"
		else
			echo "ERROR: Could not detect any known ramdisk format!"
			exit 1
		fi

		echo "INFO: Extracting ramdisk..."
		$DBIN ../boot.img-ramdisk.gz | cpio -i

		# Detect AOSP/Samsung variant based on existing modules in ramdisk
		if [[ -d "$AKDROP/ramdisk/lib/modules" ]]; then
			echo "INFO: Detected Samsung variant"

			# Remove all current modules from ramdisk
			find "$AKDROP/ramdisk/lib/modules" -type f -iname "*.ko" | while read line; do
				rm "$line"
			done

			# Copy all new ArchiKernel modules from system to ramdisk
			find "/system/lib/modules" -type f -iname "*.ko" | while read line; do
				cp "$line" "$AKDROP/ramdisk/lib/modules"
			done

			# We're on Sammy so we have no use of system modules, delete them to avoid confusion
			rm -rf "/system/lib/modules"
		else
			echo "INFO: Detected AOSP variant"
		fi

		# If we have any ramdisk content, write it
		if [[ -d "$AK/ramdisk" ]]; then
			echo "INFO: Overwriting ramdisk with custom content"
			find "$AK/ramdisk" -mindepth 1 -maxdepth 1 | while read line; do
				cp -pR "$line" .
			done
		fi

		# If we have any executable files/folders, chmod them
		TO755="sbin res/synapse/actions"
		for FILE in $TO755; do
			if [[ -e "$AKDROP/ramdisk/$FILE" ]]; then
				chmod -R 755 "$AKDROP/ramdisk/$FILE"
			fi
		done

		# Add ArchiKernel Init if required
		if grep -q "ArchiKernel-Init" "$AKDROP/ramdisk/init.rc"; then
			echo "INFO: User is updating the kernel!"
		else
			echo "INFO: User is flashing the kernel for the first time!"
			{
				echo
				echo "service ArchiKernel-Init /sbin/ArchiKernel-Init"
				echo "    class main"
				echo "    user root"
				echo "    group root"
				echo "    oneshot"
			} >> "$AKDROP/ramdisk/init.rc"
		fi

		find . | cpio -o -H newc | $CBIN > "$AKDROP/boot.img-ramdisk.gz"
	fi
else
	echo "ERROR: No ramdisk?!"
	exit 2
fi
echo "INFO: Combining ArchiKernel zImage and current kernel ramdisk"
"$AK/mkbootimg-static" \
	--kernel "$AK/zImage" \
	--ramdisk "$AKDROP/boot.img-ramdisk.gz" \
	--cmdline "$(cat $AKDROP/boot.img-cmdline)" \
	--board "$(cat $AKDROP/boot.img-board)" \
	--base "$(cat $AKDROP/boot.img-base)" \
	--pagesize "$(cat $AKDROP/boot.img-pagesize)" \
	--kernel_offset "$(cat $AKDROP/boot.img-kerneloff)" \
	--ramdisk_offset "$(cat $AKDROP/boot.img-ramdiskoff)" \
	--tags_offset "$(cat $AKDROP/boot.img-tagsoff)" \
	--output "$AK/newboot.img"

echo "INFO: newboot.img ready!"

echo "INFO: Flashing newboot.img on $KERNEL"
if which flash_image >/dev/null; then
	flash_image "$KERNEL" "$AK/newboot.img"
else
	dd if="$AK/newboot.img" of="$KERNEL"
fi

echo "SUCCESS: Everything finished successfully!"
touch "$AK/_OK"
date

exit 0
