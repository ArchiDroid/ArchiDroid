#!/bin/bash

#     _             _     _ ____            _     _
#    / \   _ __ ___| |__ (_)  _ \ _ __ ___ (_) __| |
#   / _ \ | '__/ __| '_ \| | | | | '__/ _ \| |/ _` |
#  / ___ \| | | (__| | | | | |_| | | | (_) | | (_| |
# /_/   \_\_|  \___|_| |_|_|____/|_|  \___/|_|\__,_|
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

# This script is used to automatically update GApps in AD github tree
# Big thanks to Open GApps contributors for providing these

set -e

arrayContainsString() {
	for e in "${@:2}"; do
		if [[ "$e" = "$1" ]]; then
			return 0
		fi
	done
	return 1
}

UPDATE=0

for ARG in "$@"; do
	case "$ARG" in
		--update) UPDATE=1 ;;
	esac
done

cd "$(dirname "$0")"

if [[ "$UPDATE" -eq 1 ]]; then
	while read ZIP; do
		GAPPSPACKAGE="$ZIP"
		break
	done < <(find . -mindepth 1 -maxdepth 1 -type f -name "open_gapps-*.zip")
else
	find . -mindepth 1 -maxdepth 1 -type f -name "open_gapps-*" -exec rm -f {} \;
	LATEST="$(curl https://api.github.com/repos/opengapps/opengapps/tags 2>/dev/null | grep "\"name\":" | head -n 1 | cut -d '"' -f 4)"
	if [[ -z "$LATEST" ]]; then
		echo "ERROR: Could not fetch last Open GApps tags"
		exit 1
	fi

	GAPPSPACKAGE="open_gapps-arm-5.1-stock-$LATEST.zip"
	wget "https://github.com/opengapps/opengapps/releases/download/$LATEST/$GAPPSPACKAGE"
fi

if [[ -z "$GAPPSPACKAGE" ]]; then
	echo "ERROR: Could not find any valid GAPPS package!"
	exit 1
fi

# Detect proper density variant
if [[ -f ../system/build.prop ]]; then
	DPI="$(grep "ro.sf.lcd_density" "../system/build.prop" | head -n 1 | cut -d '=' -f2)"
	echo "INFO: Will try to use $DPI variant if possible!"
fi

rm -rf tmp-gapps
mkdir tmp-gapps
cd tmp-gapps

unzip "../$(basename "$GAPPSPACKAGE")"

# Core files
rm -rf "../../_archidroid/gapps/base"
while read TAR; do
	PACKAGE="$(basename "$TAR" | cut -d '.' -f 1)"

	rm -rf tmp-gapps
	mkdir tmp-gapps
	cd tmp-gapps

	tar xf "../$TAR"

	# Common
	if [[ -d "$PACKAGE/common" ]]; then
		while read FILE; do
			cp -R "$FILE" "../../../_archidroid/gapps/base"
		done < <(find "$PACKAGE/common" -mindepth 1 -maxdepth 1)
	fi

	# Main
	if [[ -n "$DPI" && -d "$PACKAGE/$DPI" ]]; then
		echo "INFO: Loaded $DPI variant for $PACKAGE"
		while read FILE; do
			cp -R "$FILE" "../../../_archidroid/gapps/base"
		done < <(find "$PACKAGE/$DPI" -mindepth 1 -maxdepth 1)
	elif [[ -d "$PACKAGE/nodpi" ]]; then
		while read FILE; do
			cp -R "$FILE" "../../../_archidroid/gapps/base"
		done < <(find "$PACKAGE/nodpi" -mindepth 1 -maxdepth 1)
	fi

	cd ..
	rm -rf tmp-gapps

	echo "DONE: $PACKAGE"
done < <(find Core -mindepth 1 -maxdepth 1 -type f -name "*.tar.xz")


# Optional files
UPDATEDEXTRAS=()
while read TAR; do
	PACKAGE="$(basename "$TAR" | cut -d '.' -f 1)"

	if [[ ! -d "../../_archidroid/gapps/extra/$PACKAGE" ]]; then
		echo "INFO: Skipping $PACKAGE"
		continue
	fi

	UPDATEDEXTRAS+=("$PACKAGE")

	rm -rf tmp-gapps
	mkdir tmp-gapps
	cd tmp-gapps

	tar xf "../$TAR"

	rm -rf "../../../_archidroid/gapps/extra/$PACKAGE"
	mkdir "../../../_archidroid/gapps/extra/$PACKAGE"

	# Common
	if [[ -d "$PACKAGE/common" ]]; then
		while read FILE; do
			cp -R "$FILE" "../../../_archidroid/gapps/extra/$PACKAGE"
		done < <(find "$PACKAGE/common" -mindepth 1 -maxdepth 1)
	fi

	# Main
	if [[ -n "$DPI" && -d "$PACKAGE/$DPI" ]]; then
		echo "INFO: Loaded $DPI variant for $PACKAGE"
		while read FILE; do
			cp -R "$FILE" "../../../_archidroid/gapps/extra/$PACKAGE"
		done < <(find "$PACKAGE/$DPI" -mindepth 1 -maxdepth 1)
	elif [[ -d "$PACKAGE/nodpi" ]]; then
		while read FILE; do
			cp -R "$FILE" "../../../_archidroid/gapps/extra/$PACKAGE"
		done < <(find "$PACKAGE/nodpi" -mindepth 1 -maxdepth 1)
	fi

	cd ..
	rm -rf tmp-gapps

	echo "DONE: $PACKAGE"
done < <(find GApps -mindepth 1 -maxdepth 1 -type f -name "*.tar.xz")

cd ..
rm -rf tmp-gapps

# Check if all extra packages have been updated
while read FOLDER; do
	PACKAGE="$(basename "$FOLDER")"
	if ! arrayContainsString "$PACKAGE" "${UPDATEDEXTRAS[@]}"; then
		echo "WARNING: $PACKAGE doesn't exist anymore!"
		rm -rf "$FOLDER"
	fi
done < <(find "../_archidroid/gapps/extra" -mindepth 1 -maxdepth 1 -type d)

exit 0
