#!/sbin/sh

#     _             _     _ ____            _     _
#    / \   _ __ ___| |__ (_)  _ \ _ __ ___ (_) __| |
#   / _ \ | '__/ __| '_ \| | | | | '__/ _ \| |/ _` |
#  / ___ \| | | (__| | | | | |_| | | | (_) | | (_| |
# /_/   \_\_|  \___|_| |_|_|____/|_|  \___/|_|\__,_|
#
# Copyright 2014-2016 Łukasz "JustArchi" Domeradzki
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

# Executes post-install chainfire's SuperSU script

set -eu

ARCH="arm64"
ARCHLIB="lib64"

if [[ -f /system/build.prop ]]; then
	ABI="$(grep "ro.product.cpu.abi=" /system/build.prop | cut -d '=' -f 2)"
	case "$ABI" in
		"arm64-v8a") ARCH="arm64"; ARCHLIB="lib64" ;;
		"armeabi-v7a") ARCH="arm"; ARCHLIB="lib" ;;
		*) exit 1
	esac
fi

mv "/system/archidroid/tmp/supersu/$ARCH/libsupol.so" "/system/$ARCHLIB/libsupol.so"
chcon -v "u:object_r:system_file:s0" "/system/$ARCHLIB/libsupol.so"

mv "/system/archidroid/tmp/supersu/$ARCH/su" "/system/xbin/su"
chmod 755 /system/xbin/su
chcon -v "u:object_r:system_file:s0" "/system/xbin/su"

mv "/system/archidroid/tmp/supersu/$ARCH/supolicy" "/system/xbin/supolicy"
chmod 755 /system/xbin/supolicy
chcon -v "u:object_r:system_file:s0" "/system/xbin/supolicy"


cp -p "/system/xbin/su" "/system/xbin/daemonsu"
cp -p "/system/xbin/su" "/system/xbin/sugote"

if [[ -f "/system/bin/mksh" ]]; then
	cp -p "/system/bin/mksh" "/system/xbin/sugote-mksh"
else
	cp -p "/system/bin/sh" "/system/xbin/sugote-mksh"
fi

mkdir -p "/system/bin/.ext"
cp -p "/system/xbin/su" "/system/bin/.ext/.su"

rm -f "/system/bin/app_process"
ln -s "/system/xbin/daemonsu" "/system/bin/app_process"

for BIT in "64" "32"; do
	if [[ -f "/system/bin/app_process${BIT}" ]]; then
		if [[ ! -f "/system/bin/app_process${BIT}_original" ]]; then
			mv "/system/bin/app_process${BIT}" "/system/bin/app_process${BIT}_original"
			ln -s "/system/xbin/daemonsu" "/system/bin/app_process${BIT}"
		fi
		if [[ ! -f "/system/bin/app_process_init" ]]; then
			cp -p "/system/bin/app_process${BIT}_original" "/system/bin/app_process_init"
		fi
		break
	fi
done

sed -i "s/persist.sys.root_access=.*/persist.sys.root_access=0/g" "/system/build.prop" # This is to silent built-in Superuser in CM
rm -rf "/system/archidroid/tmp/supersu"

exit 0
