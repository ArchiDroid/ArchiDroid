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

set -eu

# Device-specific
KERNEL="/dev/block/mmcblk0p5" # THIS IS FOR GALAXY S3 ONLY

# Device-specific quirks, enable as needed
FORCE_POOR_COMPRESSION_CBIN="gzip -9" # Put custom CBIN, e.g. "gzip -9" if LZO/LZ4 ramdisks should be repacked with other compression algorithm instead
LZOP_LIES=0 # Enable if lzop -t lies
LZ4_LIES=1 # Enable if lz4 -t lies

# Global
AK="/tmp/archikernel"
AKDROP="$AK/drop"

SUPPORTS_GZIP=0
SUPPORTS_BZIP2=0
SUPPORTS_LZMA=0
SUPPORTS_XZ=0
SUPPORTS_LZOP=0
SUPPORTS_LZ4=0

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
	if [[ "$SUPPORTS_GZIP" -eq 1 ]] && gzip -t "$1" >/dev/null 2>&1; then
		echo "INFO: GZIP format detected"
		CBIN="gzip -9"
		DBIN="gzip -dc"
	elif [[ "$SUPPORTS_BZIP2" -eq 1 ]] && bzip2 -t "$1" >/dev/null 2>&1; then
		echo "INFO: BZIP2 format detected"
		CBIN="bzip2 -9"
		DBIN="bzip2 -dc"
	elif [[ "$SUPPORTS_LZMA" -eq 1 ]] && lzma -t "$1" >/dev/null 2>&1; then
		echo "INFO: LZMA format detected"
		CBIN="lzma -9"
		DBIN="lzma -dc"
	elif [[ "$SUPPORTS_XZ" -eq 1 ]] && xz -t "$1" >/dev/null 2>&1; then
		echo "INFO: XZ format detected"
		CBIN="xz -9"
		DBIN="xz -dc"
	elif [[ "$SUPPORTS_LZOP" -eq 1 && "$LZOP_LIES" -eq 0 ]] && lzop -t "$1" >/dev/null 2>&1; then
		echo "INFO: LZO format detected"
		CBIN="lzop -6"
		DBIN="lzop -dc"
		if [[ -n "$FORCE_POOR_COMPRESSION_CBIN" ]]; then
			CBIN="$FORCE_POOR_COMPRESSION_CBIN"
		fi
	elif [[ "$SUPPORTS_LZ4" -eq 1 && "$LZ4_LIES" -eq 0 ]] && lz4 -t "$1" >/dev/null 2>&1; then
		echo "INFO: LZ4 format detected"
		CBIN="lz4 -9"
		DBIN="lz4 -dc"
		if [[ -n "$FORCE_POOR_COMPRESSION_CBIN" ]]; then
			CBIN="$FORCE_POOR_COMPRESSION_CBIN"
		fi
	else
		CBIN="raw"
		DBIN="raw"
		echo "INFO: Could not detect any known ramdisk compression format!"
		echo "INFO: Will try uncompressed (raw) mode!"
	fi

	if [[ "$DBIN" != "raw" ]]; then
		$DBIN "$1" | cpio -i || return 1
	else
		cpio -i < "$1" || return 1
	fi

	rm -f "$1" # We don't need you anymore

	echo "INFO: Success!"
}

REPACK_RAMDISK() {
	# $1 - Extracted ramdisk source (folder)
	# $2 - Repacked ramdisk target (file)
	# $3 - Compression type
	cd "$1" || return 1

	echo "INFO: Repacking $1 folder into $2 ramdisk using $3 compression type"

	if [[ "$3" != "raw" ]]; then
		find . | cpio -o -H newc | $3 > "$2"
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
		find "lib/modules" -type f -name "*.ko" | while read -r KO; do
			rm -f "$KO"
		done

		# Copy all new ArchiKernel modules from system to ramdisk
		find "/system/lib/modules" -type f -name "*.ko" | while read -r KO; do
			cp "$KO" "lib/modules/"
		done

		# We're on Sammy so we have no use of system modules, delete them to avoid confusion
		rm -rf "/system/lib/modules"
	else
		echo "INFO: Detected AOSP variant"
	fi

	# If we have any ramdisk content, write it
	if [[ -d "$AK/ramdisk" ]]; then
		echo "INFO: Overwriting ramdisk with custom content"
		find "$AK/ramdisk" -mindepth 1 -maxdepth 1 | while read -r TOCOPY; do
			cp -pR "$TOCOPY" .
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
		echo "INFO: User is flashing the kernel for the first time"
		{
			echo
			echo "service ArchiKernel-Init /sbin/ArchiKernel-Init"
			echo "    class main"
			echo "    user root"
			echo "    group root"
			echo "    oneshot"
		} >> "init.rc"
		echo "INFO: Added ArchiKernel-Init service to init.rc"
	fi
}

exec 1>"$AK/ArchiKernel.log"
exec 2>&1

date
echo "INFO: ArchiKernel flasher ready!"
echo "INFO: Safety check: ON, flasher will immediately terminate in case of ANY error"

# Check if recovery has cpio command
if ! which cpio >/dev/null; then
	echo "ERROR: Recovery doesn't know how to parse ramdisk file!"
	exit 1
fi

# Detect supported formats
if which gzip >/dev/null; then
	SUPPORTS_GZIP=1
	echo "INFO: Recovery understands GZIP? [YES]"
else
	echo "INFO: Recovery understands GZIP? [NO]"
fi

if which bzip2 >/dev/null; then
	SUPPORTS_BZIP2=1
	echo "INFO: Recovery understands BZIP2? [YES]"
else
	echo "INFO: Recovery understands BZIP2? [NO]"
fi

if which lzma >/dev/null; then
	SUPPORTS_LZMA=1
	echo "INFO: Recovery understands LZMA? [YES]"
else
	echo "INFO: Recovery understands LZMA? [NO]"
fi

if which xz >/dev/null; then
	SUPPORTS_XZ=1
	echo "INFO: Recovery understands XZ? [YES]"
else
	echo "INFO: Recovery understands XZ? [NO]"
fi

if which lzop >/dev/null; then
	SUPPORTS_LZOP=1
	echo "INFO: Recovery understands LZO? [YES]"
else
	echo "INFO: Recovery understands LZO? [NO]"
fi

if which lz4 >/dev/null; then
	SUPPORTS_LZ4=1
	echo "INFO: Recovery understands LZ4? [YES]"
else
	echo "INFO: Recovery understands LZ4? [NO]"
fi


if [[ ! -f "$AK/mkbootimg-static" || ! -f "$AK/unpackbootimg-static" ]]; then
	echo "ERROR: No bootimg tools detected!"
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
RAMDISK2="$AKDROP/ramdisk2" # Used in kernel + recovery combo

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
	echo "ERROR: No ramdisk detected!"
	exit 1
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
date
touch "$AK/_OK"

exit 0
