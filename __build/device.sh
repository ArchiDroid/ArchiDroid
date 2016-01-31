#!/bin/bash

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

# This script should define device-based properties

DEVICE_CODENAME="oneplus2" # This is AOSP variant to build, the one used in brunch command. If you use "brunch i9300", you should set it to i9300
DEVICE_BUILDVARIANT="userdebug" # "user" is best, but requires extra fixes, so "userdebug" is default

# Apart from above, don't forget to:
# 1. Copy permission and symlinks to updater-script after first build
# 2. Copy appropriate overlay from "_devices" directory
# 3. Set device properties also in aroma-config
# 4. Put proper GAPPS using gapps.sh
# 5. I most likely forgot about something anyway, will update as needed

return
