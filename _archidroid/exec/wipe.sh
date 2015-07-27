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

# Wipes /data partition excluding internal storage (/data/media)

set -e

find /data -mindepth 1 -maxdepth 1 | while read FILE; do
	case "$FILE" in
		"/data/.layout_version") ;; # Don't wipe layout version
		"/data/media") ;; # Don't wipe internal storage
		*) rm -rf "$FILE"
	esac
done

# Add layout version if needed
if [[ ! -f "/data/.layout_version" ]]; then
	printf "3" > "/data/.layout_version"
fi

exit 0
