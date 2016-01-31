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

# Returns modification date of ArchiDroid.zip, if possible
# String is returned on success

set -eu
exec 2>/dev/null

SUCCESS=0
ZIPFILE="$(ps | grep [u]pdater | head -n 1 | awk '{print $NF}')" # Assume that zip path is last given parameter

if [[ -n "$ZIPFILE" && -f "$ZIPFILE" ]]; then
	MODIFIED="$(stat "$ZIPFILE" | grep "Modify:" | cut -d ' ' -f 2)"
	if [[ -n "$MODIFIED" ]]; then
		SUCCESS=1
		echo "$MODIFIED" | tr -d '\n'
	fi
fi

if [[ "$SUCCESS" -eq 0 ]]; then
	printf "Unknown"
fi

exit 0
