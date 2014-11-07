#!/bin/bash

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

# This script is used to update repos according to current UPSTREAMs
# It should be used only by repo owners with write access
# Don't bother if you don't have your own repos with upstreams, like android_build

REPO="origin"

CUSTOMREPOS="lge-kernel-lproj Superuser"
REPO_DEPENDS_ON_UPSTREAM() {
	# If it begins with android_, we definitely want this
	if [[ "$1" = android_* ]]; then
		return 0
	# Same situation with proprietary
	elif [[ "$1" = proprietary_* ]]; then
		return 0
	# If everything else fails, check for some predefined repos
	else
		for CUSTOMREPO in $CUSTOMREPOS; do
			if [[ "$CUSTOMREPO" = "$1" ]]; then
				return 0
			fi
		done
	fi
	return 1
}

UPDATEREPO() {
	cd "$1" || return 1
	CURBRANCH="$(git rev-parse --abbrev-ref HEAD)"
	git pull "$REPO" "$CURBRANCH" >/dev/null 2>&1
	if [[ -f "UPSTREAMS" ]]; then
		while read UPSTREAM; do
			git pull "https://github.com/$UPSTREAM" "$CURBRANCH" >/dev/null 2>&1
			if [[ $? -ne 0 ]]; then
				# This is mandatory, we MUST stay in sync with upstream
				git reset --hard >/dev/null 2>&1
				git clean -fd >/dev/null 2>&1
				git pull "https://github.com/$UPSTREAM" "$CURBRANCH" >/dev/null 2>&1
				if [[ $? -ne 0 ]]; then
					git reset --hard >/dev/null 2>&1
					git clean -fd >/dev/null 2>&1
					echo "ERROR: Something went wrong with: $(basename "$1")"
					return 1
				fi
			fi
		done < UPSTREAMS
	fi
	git push "$REPO" "$CURBRANCH"
	return $?
}

while read line; do
	if [[ ! -d "$line" ]] && REPO_DEPENDS_ON_UPSTREAM "$line"; then
		echo "INFO: Adding missing $line repo"
		git clone "https://github.com/ArchiDroid/$line" &
	elif [[ -d "$line/.git" ]]; then
		echo "INFO: Updating $line"
		UPDATEREPO "$line" &
	else
		echo "INFO: Not interested in $line"
	fi
done < <(curl https://api.github.com/users/ArchiDroid/repos 2>/dev/null | grep "\"name\":" | cut -d '"' -f4)

wait

exit 0
