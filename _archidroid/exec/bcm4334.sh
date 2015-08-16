#!/sbin/sh

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

# Sets proper firmware as default fallback
# $1 - Target firmware. Can be either: stock, archidetect (requires detection firstly) or any valid string from bcm4334_*.hcd

set -e

if [[ -z "$1" ]]; then
	exit 1
fi

BCM="$1"

case "$BCM" in
	"stock") exit 0 ;;
	"archidetect")
		if [[ -f "/tmp/archidroid/bcm4334" ]]; then
			BCM="$(cat "/tmp/archidroid/bcm4334")"
			rm -f "/tmp/archidroid/bcm4334"
		else
			exit 1
		fi
	;;
esac

# Detect BCM firmware location
if [[ -f "/system/bin/bcm4334.hcd" ]]; then
	FWPATH="/system/bin"
elif [[ -f "/system/vendor/firmware/bluetooth/bcm4334.hcd" ]]; then
	FWPATH="/system/vendor/firmware/bluetooth"
else
	exit 1
fi

if [[ -f "$FWPATH/bcm4334_$BCM.hcd" ]]; then
	cp -p "$FWPATH/bcm4334_$BCM.hcd" "$FWPATH/bcm4334.hcd"
	if [[ ! -f "/data/.cid.info" ]]; then
		printf "%s" "$BCM" > "/data/.cid.info"
		chmod 666 "/data/.cid.info"
		chown 1000:1000 "/data/.cid.info"
	fi
else
	exit 1
fi

exit 0
