#!/bin/bash

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

set -eu

# Exit if stdout is not TTY
if [[ ! -t 1 ]]; then
	xmessage -center -font -bitstream-terminal-bold-r-normal--20-140-100-100-c-110-iso8859-1 "You must execute this script in terminal!"
	exit 1
fi

# Exit immediately if we've already installed full lxde
if dpkg -s "lxde" >/dev/null 2>&1; then
	xmessage -center -font -bitstream-terminal-bold-r-normal--20-140-100-100-c-110-iso8859-1 "You've already installed full LXDE!"
	exit 0
fi

xmessage -timeout 5 -center -font -bitstream-terminal-bold-r-normal--20-140-100-100-c-110-iso8859-1 "Be patient!"

apt-get -f install # Fix APT packages if needed
apt-get update
apt-get -y install lxde

# Restart XORG if possible
XORG_PID="$(pidof "X")"
if [[ -n "$XORG_PID" && -e "/proc/$XORG_PID" ]]; then
	touch /tmp/ARCHIDROID_XORG_RESTART
	kill "$XORG_PID"
fi
