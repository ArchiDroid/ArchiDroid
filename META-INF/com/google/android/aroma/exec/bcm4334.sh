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

BCM="Unknown"
SUCCESS=0

DETECT_BCM() {
	if [[ -f "/data/.cid.info" ]]; then
		BCM="$(cat "/data/.cid.info")"
		if [[ ! -z "$BCM" ]]; then
			SUCCESS=1
			return
		fi
	fi
	if [[ -f "/efs/wifi/.mac.info" ]]; then
		BCM="$(tr '[:upper:]' '[:lower:]' < "/efs/wifi/.mac.info")"
		case "$BCM" in # Ref: https://github.com/CyanogenMod/android_hardware_samsung/blob/cm-12.0/macloader/macloader.cpp
			# murata
			"00:0e:6d"*) BCM="murata" ;;
			"00:13:e0"*) BCM="murata" ;;
			"00:21:e8"*) BCM="murata" ;;
			"00:26:e8"*) BCM="murata" ;;
			"00:37:6d"*) BCM="murata" ;;
			"00:60:57"*) BCM="murata" ;;
			"04:46:65"*) BCM="murata" ;;
			"10:5f:06"*) BCM="murata" ;;
			"10:a5:d0"*) BCM="murata" ;;
			"1c:99:4c"*) BCM="murata" ;;
			"14:7d:c5"*) BCM="murata" ;;
			"20:02:af"*) BCM="murata" ;;
			"40:f3:08"*) BCM="murata" ;;
			"44:a7:cf"*) BCM="murata" ;;
			"5c:da:d4"*) BCM="murata" ;;
			"5c:f8:a1"*) BCM="murata" ;;
			"78:4b:87"*) BCM="murata" ;;
			"60:21:c0"*) BCM="murata" ;;
			"88:30:8a"*) BCM="murata" ;;
			"f0:27:65"*) BCM="murata" ;;

			# semco3rd
			"f4:09:d8"*) BCM="semco3rd" ;;

			# semcosh
			"38:aa:3c"*) BCM="semcosh" ;;
			"5c:0a:5b"*) BCM="semcosh" ;;
			"cc:3a:61"*) BCM="semcosh" ;;

			# wisol
			"48:5a:3f"*) BCM="wisol" ;;

			# Unknown
			*) BCM="Unknown, $BCM" ;;
		esac
		if [[ ! -z "$BCM" && "$BCM" != Unknown* ]]; then
			SUCCESS=1
			return
		fi
	fi
}

DETECT_BCM

if [[ "$SUCCESS" -eq 1 ]]; then
	echo "$BCM" > "/tmp/archidroid/bcm4334"
fi

echo "$BCM"

exit 0
