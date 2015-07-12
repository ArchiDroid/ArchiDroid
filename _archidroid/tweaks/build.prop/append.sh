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

# Appends togglable tweaks to build.prop

set -e

cat >> /system/build.prop <<EOF
### ArchiDroid build.prop tweaks START ###

# Disable bootanimation
#debug.sf.nobootanimation=1

# Allow purging of assets
persist.sys.purgeable_assets=1

# Force navigation bar
#qemu.hw.mainkeys=0

# Enables low ram mode, which deactivates some eye-candy memory-intensive tasks
#ro.config.low_ram=true

### ArchiDroid build.prop tweaks END ###
EOF

exit 0
