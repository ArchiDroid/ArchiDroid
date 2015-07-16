#!/bin/bash

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

set -e

if [[ -z "${CROSS_COMPILE}" ]]; then
	echo "ERROR: Make sure that \${CROSS_COMPILE} variable is set!"
	exit 1
elif ! which "${CROSS_COMPILE}gcc" >/dev/null; then
	echo "ERROR: Make sure that ${CROSS_COMPILE}gcc is available!"
	exit 1
elif ! which "${CROSS_COMPILE}strip" >/dev/null; then
	echo "ERROR: Make sure that ${CROSS_COMPILE}strip is available!"
	exit 1
fi

CFLAGS=(-O3 -std=c11 -pedantic -Wall -Werror -march=armv7-a -mfpu=neon -mfloat-abi=softfp -fmodulo-sched -fmodulo-sched-allow-regmoves -funsafe-loop-optimizations -fsection-anchors -fivopts -ftree-loop-im -ftree-loop-ivcanon -ffunction-sections -fdata-sections -funswitch-loops -frename-registers -fomit-frame-pointer -fgcse-sm -fgcse-las -fweb -ftracer -fstrict-aliasing -flto -s -fvisibility=hidden -fPIC -fPIE -pie -DNDEBUG -D__ANDROID__ -DANDROID)
LDFLAGS=(-Wl,-O3 -Wl,-flto -Wl,--as-needed -Wl,--gc-sections -Wl,--relax -Wl,--sort-common)
SRCFLAGS=(-DLINUX -DPIC -DPIE)

if [[ -n "$SYSROOT" ]]; then
	CFLAGS+=("--sysroot=$SYSROOT")
fi

cd "$(dirname "$0")"

# addebuggerd
"${CROSS_COMPILE}gcc" "${SRCFLAGS[@]}" "${CFLAGS[@]}" "${LDFLAGS[@]}" -o /tmp/addebuggerd addebuggerd.c && mv /tmp/addebuggerd addebuggerd
"${CROSS_COMPILE}strip" -s -R .note -R .comment -R .gnu.version -R .gnu.version_r addebuggerd

if [[ -f "../../_archidroid/auto/system/bin/addebuggerd" ]]; then
	cp "addebuggerd" "../../_archidroid/auto/system/bin/addebuggerd"
fi

# addnsmasq
"${CROSS_COMPILE}gcc" "${SRCFLAGS[@]}" "${CFLAGS[@]}" "${LDFLAGS[@]}" -o /tmp/addnsmasq addnsmasq.c && mv /tmp/addnsmasq addnsmasq
"${CROSS_COMPILE}strip" -s -R .note -R .comment -R .gnu.version -R .gnu.version_r addnsmasq

if [[ -f "../../_archidroid/auto/system/bin/addnsmasq" ]]; then
	cp "addnsmasq" "../../_archidroid/auto/system/bin/addnsmasq"
fi

exit 0
