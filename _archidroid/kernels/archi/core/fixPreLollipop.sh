#!/sbin/sh

#     _             _     _ _  __                    _
#    / \   _ __ ___| |__ (_) |/ /___ _ __ _ __   ___| |
#   / _ \ | '__/ __| '_ \| | ' // _ \ '__| '_ \ / _ \ |
#  / ___ \| | | (__| | | | | . \  __/ |  | | | |  __/ |
# /_/   \_\_|  \___|_| |_|_|_|\_\___|_|  |_| |_|\___|_|
#
# Copyright 2015 Łukasz "JustArchi" Domeradzki
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

# exit 0 -> All fine, we're running Lollipop+
# exit 1 -> All fine, we're running pre-Lollipop
# exit 2 -> No build.prop detected, or invalid value, assume Lollipop+

APKS="/system/app/Synapse/Synapse.apk"

if [[ -f "/system/build.prop" ]]; then
	SDK="$(grep "ro.build.version.sdk" "/system/build.prop" | cut -d '=' -f 2)"
	if [[ -n "$SDK" ]]; then
		if [[ "$SDK" -ge 21 ]]; then
			exit 0
		else
			for APK in $APKS; do
				APK_DIR="$(dirname "$APK")"
				mv "$APK" "${APK_DIR}/../"
				rm -rf "$APK_DIR"
			done
			exit 1
		fi
	else
		exit 2
	fi
else
	exit 2
fi

exit 0
