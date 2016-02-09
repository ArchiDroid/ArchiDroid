#!/bin/bash

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

set -eu

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

CFLAGS=(-Wall -Werror -pedantic -std=gnu11 -O3 -march=armv7-a -mfpu=neon -mfloat-abi=softfp -fgcse-las -fgcse-sm -fipa-pta -fivopts -fomit-frame-pointer -frename-registers -fsection-anchors -ftree-loop-im -ftree-loop-ivcanon -funsafe-loop-optimizations -funswitch-loops -fweb -fgraphite -fgraphite-identity -floop-block -floop-interchange -floop-nest-optimize -floop-parallelize-all -floop-strip-mine -fmodulo-sched -fmodulo-sched-allow-regmoves -ffunction-sections -fdata-sections -fvisibility=hidden -s -flto -fPIC -fPIE -pie -DNDEBUG -D__ANDROID__ -DANDROID)
LDFLAGS=(-llog -Wl,-O3 -Wl,--as-needed -Wl,--relax -Wl,--sort-common -Wl,--gc-sections -Wl,-flto -fPIE -fPIC -pie)
SRCFLAGS=(-DLINUX -DPIC -DPIE)
STRIPFLAGS=(-s -R .note -R .comment -R .gnu.version -R .gnu.version_r)

if [[ -n "$SYSROOT" ]]; then
	CFLAGS+=("--sysroot=$SYSROOT")
fi

cd "$(dirname "$(readlink -f "$0")")"

# addebuggerd
"${CROSS_COMPILE}gcc" "${SRCFLAGS[@]}" "${CFLAGS[@]}" "${LDFLAGS[@]}" -o /tmp/addebuggerd addebuggerd.c
"${CROSS_COMPILE}strip" "${STRIPFLAGS[@]}" /tmp/addebuggerd
mv /tmp/addebuggerd addebuggerd

if [[ -f "../../_archidroid/auto/system/bin/addebuggerd" ]]; then
	cp "addebuggerd" "../../_archidroid/auto/system/bin/addebuggerd"
fi

# addnsmasq
"${CROSS_COMPILE}gcc" "${SRCFLAGS[@]}" "${CFLAGS[@]}" "${LDFLAGS[@]}" -o /tmp/addnsmasq addnsmasq.c
"${CROSS_COMPILE}strip" "${STRIPFLAGS[@]}" /tmp/addnsmasq
mv /tmp/addnsmasq addnsmasq

if [[ -f "../../_archidroid/auto/system/bin/addnsmasq" ]]; then
	cp "addnsmasq" "../../_archidroid/auto/system/bin/addnsmasq"
fi

exit 0
