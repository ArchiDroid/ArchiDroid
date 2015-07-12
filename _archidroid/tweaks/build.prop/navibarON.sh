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

# Forces navigation bar to be shown
# $1 - A boolean value indicating whether to keep hardware buttons working or not

set -e

if [[ -z "$1" ]]; then
	exit 1
fi

case "$1" in
	1|yes|true) HWENABLED=1 ;;
	0|no|false) HWENABLED=0 ;;
	*) exit 1
esac

if grep -q "#qemu.hw.mainkeys=0" "/system/build.prop"; then
	sed -i "s/#qemu.hw.mainkeys=0/qemu.hw.mainkeys=0/g" /system/build.prop
else
	echo "qemu.hw.mainkeys=0" >> /system/build.prop
fi

# Disable hardware keys if needed
if [[ "$HWENABLED" -eq 0 ]]; then
	KEYS="139 158 172" # MENU, BACK, HOME
	find /system/usr/keylayout -type f -name "*.kl" | while read FILE; do
		for KEY in $KEYS; do
			sed -i "s/key $KEY/#key $KEY/g" "$FILE"
		done
	done
fi

exit 0
