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

# This script is used to update languages
# It supports adding strings, and removing them

set -e

SCRIPTDIR="$(dirname "$0")"

MODE="$1"
LINE="$2"
STRING="$3"

case "$MODE" in
	add|ADD)
		if [[ $# -lt 3 ]]; then
			echo "ERROR: Syntax: add <AfterWhichLine> <String>"
			exit 1
		fi
		find "$SCRIPTDIR/../META-INF/com/google/android/aroma/langs" -mindepth 1 -maxdepth 1 -type f -iname "*.lang" | while read FILE; do
			LENGTH="$(wc -l < "$FILE")"
			head -n "$LINE" "$FILE" > temp.lang
			echo "$STRING" >> temp.lang
			tail -n "$(($LENGTH - $LINE))" "$FILE" >> temp.lang
			mv temp.lang "$FILE"
		done
	;;
	del|DEL)
		if [[ $# -lt 2 ]]; then
			echo "ERROR: Syntax: del <WhichLine>"
			exit 1
		fi
		find "$SCRIPTDIR/../META-INF/com/google/android/aroma/langs" -mindepth 1 -maxdepth 1 -type f -iname "*.lang" | while read FILE; do
			LENGTH="$(wc -l < "$FILE")"
			head -n "$(($LINE - 1))" "$FILE" > temp.lang
			tail -n "$(($LENGTH - $LINE))" "$FILE" >> temp.lang
			mv temp.lang "$FILE"
		done
	;;
	*)
		echo "ERROR: You specified wrong mode, valid: add/del"
		exit 1
	;;
esac

exit 0
