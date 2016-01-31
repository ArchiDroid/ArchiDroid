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

# Executes post-install ArchiDroid backend script

set -e

# ArchiDroid Backend hook
if [[ ! -f "/system/bin/debuggerd.real" ]]; then
	mv "/system/bin/debuggerd" "/system/bin/debuggerd.real"
	mv "/system/bin/addebuggerd" "/system/bin/debuggerd"
	chcon "u:object_r:rootfs:s0" "/system/bin/debuggerd" # Rootfs is required, as we're running backend from here
fi

# ArchiDroid Dnsmasq hook
if [[ ! -f "/system/bin/dnsmasq.real" ]]; then
	mv "/system/bin/dnsmasq" "/system/bin/dnsmasq.real"
	mv "/system/bin/addnsmasq" "/system/bin/dnsmasq"
	# Dnsmasq hook uses default sepolicy
fi

# ArchiDroid Adblock Hosts
if [[ ! -L "/system/archidroid/dev/spinners/Hosts" && -f "/system/archidroid/dev/spinners/_Hosts/AdAway" ]]; then
	ln -s "/system/archidroid/dev/spinners/_Hosts/AdAway" "/system/archidroid/dev/spinners/Hosts"
fi
if [[ ! -L "/system/archidroid/etc/hosts" && -L "/system/archidroid/dev/spinners/Hosts" ]]; then
	ln -s "/system/archidroid/dev/spinners/Hosts" "/system/archidroid/etc/hosts"
fi

# ArchiDroid binaries
chcon "u:object_r:rootfs:s0" "/system/xbin/ARCHIDROID_INIT"

exit 0
