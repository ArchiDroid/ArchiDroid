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

# Used by ArchiDroid for providing universal device-based paths
# Usage: adumount.sh [Path] e.g. adumount.sh /storage/sdcard1

LOG="/tmp/adumount.log" # We can use /dev/null if not required

exec 1>>"$LOG"
exec 2>&1

echo "INFO: $(basename "$0") called!"
echo "INFO: Arguments: $*"

# shellcheck disable=2039
if [[ -z "$1" ]]; then
	echo "ERROR: Wrong arguments!"
	echo "ERROR: Expected: [Path]"
	exit 1
fi

ADMOUNTED() {
	return "$(mount | grep -qi "$1"; echo $?)"
}

if ! ADMOUNTED "$1"; then
	echo "SUCCESS: $1 is unmounted already!"
	exit 0
fi

# Stage 1 
echo "INFO: Trying umount"
umount "$1"
if ! ADMOUNTED "$1"; then
	echo "SUCCESS: $1 has been unmounted properly!"
	exit 0
else
	echo "INFO: Failed!"
fi

echo "ERROR: All stages failed, we're not able to unmount that!"
exit 1
