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

HWENABLED="$1"

# Enable navigation bar
if [[ "$(grep -q "#qemu.hw.mainkeys=0" "/system/build.prop"; echo $?)" -eq 0 ]]; then
	sed -i 's/#qemu.hw.mainkeys=0/qemu.hw.mainkeys=0/g' /system/build.prop
else
	echo "qemu.hw.mainkeys=0" >> /system/build.prop
fi

if [[ "$HWENABLED" -ne 1 ]]; then
	KEYS="139 158 172" # MENU, BACK, HOME
	find /system/usr/keylayout -type f -name "*.kl" | while read line; do
		for KEY in $KEYS; do
			sed -i "s/key $KEY/#key $KEY/g" "$line"
		done
	done
fi

exit 0
