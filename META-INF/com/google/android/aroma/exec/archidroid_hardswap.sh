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

# Managed ArchiDroid Hardswap
# $1 - Hardswap file directory
# $2 - Hardswap file size in megabytes

set -e

if [[ -z "$1" || -z "$2" ]]; then
	exit 1
fi

# Check if device is available
if ! mount | grep -qi "$1"; then
	exit 1
fi

# Remove old hardswap file
rm -f "$1/ArchiDroid.swp"

# If size is greater than 0, make new hardswap file
if [[ "$2" -gt 0 ]]; then
	FREESPACE="$(df -m "$1" | tail -n 1 | awk '{print $4}')"
	if [[ "$FREESPACE" -lt "$2" ]]; then
		exit 1
	fi
	dd if=/dev/zero of="$1/ArchiDroid.swp" bs=1M count="$2"
	mkswap "$1/ArchiDroid.swp"
	chown 0:0 "$1/ArchiDroid.swp" # We don't want to create
	chmod 0600 "$1/ArchiDroid.swp" # A potential security risk
fi

exit 0
