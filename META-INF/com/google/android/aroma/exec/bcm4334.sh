#!/sbin/sh

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

BCM="unknown"

DETECT_BCM() {
	if [[ -f "/data/.cid.info" ]]; then
		BCMPROBE="$(cat "/data/.cid.info")"
		if [[ ! -z "$BCMPROBE" ]]; then
			BCM="$BCMPROBE"
			return
		fi
	fi
	if [[ -f "/efs/wifi/.mac.info" ]]; then
		BCMPROBE="$(cat "/efs/wifi/.mac.info" | tr '[:upper:]' '[:lower:]')"
		case "$BCMPROBE" in # Ref: https://github.com/CyanogenMod/android_hardware_samsung/blob/cm-11.0/macloader/macloader.cpp
			# Murata
			"00:0e:6d"*) BCMPROBE="murata" ;;
			"00:13:e0"*) BCMPROBE="murata" ;;
			"00:21:e8"*) BCMPROBE="murata" ;;
			"00:26:e8"*) BCMPROBE="murata" ;;
			"00:37:6d"*) BCMPROBE="murata" ;;
			"00:60:57"*) BCMPROBE="murata" ;;
			"04:46:65"*) BCMPROBE="murata" ;;
			"10:5f:06"*) BCMPROBE="murata" ;;
			"10:a5:d0"*) BCMPROBE="murata" ;;
			"1c:99:4c"*) BCMPROBE="murata" ;;
			"14:7d:c5"*) BCMPROBE="murata" ;;
			"20:02:af"*) BCMPROBE="murata" ;;
			"40:f3:08"*) BCMPROBE="murata" ;;
			"44:a7:cf"*) BCMPROBE="murata" ;;
			"5c:da:d4"*) BCMPROBE="murata" ;;
			"5c:f8:a1"*) BCMPROBE="murata" ;;
			"78:4b:87"*) BCMPROBE="murata" ;;
			"60:21:c0"*) BCMPROBE="murata" ;;
			"88:30:8a"*) BCMPROBE="murata" ;;
			"f0:27:65"*) BCMPROBE="murata" ;;
			# Semcosh
			"38:aa:3c"*) BCMPROBE="semcosh" ;;
			"5c:0a:5b"*) BCMPROBE="semcosh" ;;
			"cc:3a:61"*) BCMPROBE="semcosh" ;;
		esac
		if [[ ! -z "$BCMPROBE" ]]; then
			BCM="$BCMPROBE"
			return
		fi
	fi
}

DETECT_BCM
echo "$BCM" > "/tmp/archidroid/bcm4334"
echo "$BCM"

exit 0
