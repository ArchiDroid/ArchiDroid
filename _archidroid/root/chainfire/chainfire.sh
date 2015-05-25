#!/sbin/sh

#     _             _     _ ____            _     _
#    / \   _ __ ___| |__ (_)  _ \ _ __ ___ (_) __| |
#   / _ \ | '__/ __| '_ \| | | | | '__/ _ \| |/ _` |
#  / ___ \| | | (__| | | | | |_| | | | (_) | | (_| |
# /_/   \_\_|  \___|_| |_|_|____/|_|  \___/|_|\__,_|
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

cp -p "/system/xbin/su" "/system/xbin/daemonsu"
cp -p "/system/xbin/su" "/system/xbin/sugote"

if [[ -f "/system/bin/mksh" ]]; then
	cp -p "/system/bin/mksh" "/system/xbin/sugote-mksh"
else
	cp -p "/system/bin/sh" "/system/xbin/sugote-mksh"
fi

mkdir -p "/system/bin/.ext"
chmod 0777 "/system/bin/.ext"
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
	fi
done

sed -i "s/persist.sys.root_access=.*/persist.sys.root_access=0/g" "/system/build.prop" # This is to silent built-in Superuser in CM

exit 0
