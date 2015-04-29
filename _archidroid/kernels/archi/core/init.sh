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
KERNEL="/dev/block/mmcblk0p17" # THIS IS FOR XPERIA M ONLY
PARSERAMDISK=1 # If we don't need to worry about compressed ramdisk (i.e. putting modules inside), we can skip it

EXTRACT_RAMDISK() {
	# $1 - Raw ramdisk source (file)
	# $2 - Extracted ramdisk target (folder)
	echo "INFO: Extracting $1 ramdisk to $2 folder"

	mkdir -p "$2"
	cd "$2" || return 1

	if [[ ! -f "$1" ]]; then
		echo "ERROR: Ramdisk $1 not found!"
		return 1
	fi

	echo "INFO: Detecting $1 ramdisk format..."
	if gunzip --help 2>&1 | grep -q "\-\-test" && gunzip --test "$1"; then
		echo "INFO: GZIP format detected"
		CBIN="gzip -9"
		DBIN="gunzip -c"
	elif lzop --help 2>&1 | grep -q "\-\-test" && lzop --test "$1"; then
		echo "INFO: LZO format detected"
		CBIN="lzop -9"
		DBIN="lzop -dc"
	elif xz --help 2>&1 | grep -q "\-\-test" && xz --test "$1"; then
		echo "INFO: XZ format detected"
		CBIN="xz -9"
		DBIN="xz -dc"
	elif lzma --help 2>&1 | grep -q "\-\-test" && lzma --test "$1"; then
		echo "INFO: LZMA format detected"
		CBIN="lzma -9"
		DBIN="lzma -dc"
	else
		CBIN="raw"
		DBIN="raw"
		echo "INFO: Could not detect any known ramdisk compression format!"
		echo "INFO: Will try uncompressed mode!"
	fi

	if [[ "$DBIN" != "raw" ]]; then
		$DBIN "$1" | cpio -i || return 1
	else
		cpio -i < "$1" || return 1
	fi

	echo "INFO: Success!"
}

REPACK_RAMDISK() {
	# $1 - Extracted ramdisk source (folder)
	# $2 - Repacked ramdisk target (file)
	# $3 - Compression type (optional)
	cd "$1" || return 1

	# Find which compression we should use
	local LOCAL_CBIN="raw" # Default to raw
	if [[ -n "$3" ]]; then
		LOCAL_CBIN="$3" # If there is argument passed, use it
	elif [[ -n "$CBIN" ]]; then
		LOCAL_CBIN="$CBIN" # Otherwise check if we have global $CBIN declared
	fi

	echo "INFO: Repacking $1 folder into $2 ramdisk using $3 compression type"

	if [[ "$LOCAL_CBIN" != "raw" ]]; then
		find . | cpio -o -H newc | $LOCAL_CBIN > "$2"
	else
		find . | cpio -o -H newc > "$2"
	fi

	rm -rf "$1" # We don't need you anymore

	echo "INFO: Success!"
}

PARSE_RAMDISK() {
	# $1 - Extracted ramdisk source (folder)
	cd "$1" || return 1

	# Check if ramdisk makes sense
	if [[ ! -f "init.rc" ]]; then
		echo "ERROR: Ramdisk does not include init.rc!"
		return 1
	fi

	# Detect AOSP/Samsung variant based on existing modules in ramdisk
	if [[ -d "lib/modules" ]]; then
		echo "INFO: Detected Samsung variant"

		# Remove all current modules from ramdisk
		find "lib/modules" -type f -name "*.ko" | while read line; do
			rm -f "$line"
		done

		# Copy all new ArchiKernel modules from system to ramdisk
		find "/system/lib/modules" -type f -name "*.ko" | while read line; do
			cp "$line" "lib/modules/"
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
		if [[ -e "$FILE" ]]; then
			chmod -R 755 "$FILE"
		fi
	done

	# Add ArchiKernel Init if required
	if grep -q "ArchiKernel-Init" "init.rc"; then
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
		} >> "init.rc"
	fi
}

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
fi

chmod 755 "$AK/mkbootimg-static" "$AK/unpackbootimg-static"

echo "INFO: Pulling boot.img from $KERNEL"
if which dump_image >/dev/null; then
	dump_image "$KERNEL" "$AK/boot.img"
else
	dd if="$KERNEL" of="$AK/boot.img"
fi

echo "INFO: Unpacking pulled boot.img"
mkdir -p "$AKDROP"
"$AK/unpackbootimg-static" -i "$AK/boot.img" -o "$AKDROP"

RAMDISK1="$AKDROP/ramdisk1"
RAMDISK2="$AKDROP/ramdisk2"

if [[ -f "$AKDROP/boot.img-ramdisk.gz" ]]; then
	echo "INFO: Ramdisk found!"
	EXTRACT_RAMDISK "$AKDROP/boot.img-ramdisk.gz" "$RAMDISK1"
	RAMDISK1_CBIN="$CBIN"

	# Detect kernel + recovery combo
	if [[ -f "$RAMDISK1/sbin/ramdisk.cpio" ]]; then
		echo "INFO: Detected kernel + recovery combo!"
		EXTRACT_RAMDISK "$RAMDISK1/sbin/ramdisk.cpio" "$RAMDISK2"
		RAMDISK2_CBIN="$CBIN"
		PARSE_RAMDISK "$RAMDISK2"
		REPACK_RAMDISK "$RAMDISK2" "$RAMDISK1/sbin/ramdisk.cpio" "$RAMDISK2_CBIN"
	else
		echo "INFO: Detected classic kernel variant (non-recovery combo)"
		PARSE_RAMDISK "$RAMDISK1"
	fi
	REPACK_RAMDISK "$RAMDISK1" "$AKDROP/boot.img-ramdisk.gz" "$RAMDISK1_CBIN"
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
