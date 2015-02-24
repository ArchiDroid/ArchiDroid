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

for BIT in "64" "32"; do
	if [[ -f "/system/bin/app_process${BIT}" && ! -f "/system/bin/app_process${BIT}_original" ]]; then
		mv "/system/bin/app_process${BIT}" "/system/bin/app_process${BIT}_original"
		ln -s "app_process${BIT}_xposed" "/system/bin/app_process${BIT}"
	fi
done
mv "/system/bin/dex2oat" "/system/bin/dex2oat.orig"
mv "/system/bin/oatdump" "/system/bin/oatdump.orig"
mv "/system/bin/patchoat" "/system/bin/patchoat.orig"
mv "/system/lib/libart.so" "/system/lib/libart.so.orig"
mv "/system/lib/libart-compiler.so" "/system/lib/libart-compiler.so.orig"
mv "/system/lib/libart-disassembler.so" "/system/lib/libart-disassembler.so.orig"
mv "/system/lib/libsigchain.so" "/system/lib/libsigchain.so.orig"

exit 0
