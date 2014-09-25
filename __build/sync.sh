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
					echo "!!!"
					echo "ERROR: Something went wrong with: $(basename "$1")"
					echo "!!!"
					return 1
				fi
			fi
		done < UPSTREAMS
	fi
	git push "$REPO" "$CURBRANCH"
	return $?
}


while read folder; do
	if [[ -d "$folder/.git" ]]; then
		UPDATEREPO "$folder" &
	fi
done < <(find . -mindepth 1 -maxdepth 1 -type d)
wait

exit 0
