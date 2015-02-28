#!/system/bin/sh

#     _             _     _ _  __                    _
#    / \   _ __ ___| |__ (_) |/ /___ _ __ _ __   ___| |
#   / _ \ | '__/ __| '_ \| | ' // _ \ '__| '_ \ / _ \ |
#  / ___ \| | | (__| | | | | . \  __/ |  | | | |  __/ |
# /_/   \_\_|  \___|_| |_|_|_|\_\___|_|  |_| |_|\___|_|
#
# Copyright 2015 Łukasz "JustArchi" Domeradzki
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

cat << EOF
{
	name:I/O,
	elements:[
		{
			SPane:{
				title:"I/O schedulers",
				description:"Set the active I/O elevator algorithm. The scheduler decides how to handle I/O requests"
			}
		},
		{
			SOptionList:{
				title:"Internal storage scheduler",
				default:"$(AK_bracket /sys/block/mmcblk0/queue/scheduler)",
				action:"AK_bracket /sys/block/mmcblk0/queue/scheduler",
				values:[
					$(
						for IOSCHED in $(sed -e 's/\[//;s/\]//' < /sys/block/mmcblk0/queue/scheduler); do
							echo ""$IOSCHED","
						done
					)
				]
			}
		},
		{
			SOptionList:{
				title:"SD card scheduler",
				default:"$(AK_bracket /sys/block/mmcblk1/queue/scheduler)",
				action:"AK_bracket /sys/block/mmcblk1/queue/scheduler",
				values:[
					$(
						for IOSCHED in $(sed -e 's/\[//;s/\]//' < /sys/block/mmcblk1/queue/scheduler); do
							echo ""$IOSCHED","
						done
					)
				]
			}
		},
		{
			SSeekBar:{
				title:"Internal storage read-ahead",
				description:"The read-ahead value on the internal phone memory.",
				max:2048, min:128, unit:" kB", step:128,
				default:$(cat /sys/block/mmcblk0/queue/read_ahead_kb),
				action:"AK_generic /sys/block/mmcblk0/queue/read_ahead_kb"
			}
		},
		{
			SSeekBar:{
				title:"SD card read-ahead",
				description:"The read-ahead value on the external SD card.",
				max:2048, min:128, unit:" kB", step:128,
				default:$(cat /sys/block/mmcblk1/queue/read_ahead_kb),
				action:"AK_generic /sys/block/mmcblk1/queue/read_ahead_kb"
			}
		},
		$(
			if [[ -e /sys/kernel/dyn_fsync/Dyn_fsync_active ]]; then
cat << _EOF
				{
					SPane:{
						title:"Dynamic fsync",
						description:"$(cat /sys/kernel/dyn_fsync/Dyn_fsync_version)"
					}
				},
				{
					SCheckBox:{
						label:"Dynamic fsync",
						description:"The dynamic fsync uses Android's early suspend / late resume interface. While screen is on, file sync is disabled, when screen goes off, a file sync is called to flush all outstanding writes and sync operates as normal. This option can provide additional smoothness related to I/O operations, for a minimal, negligible chance of data loss, in case of kernel panics",
						default:$(AK_generic /sys/kernel/dyn_fsync/Dyn_fsync_active),
						action:"AK_generic /sys/kernel/dyn_fsync/Dyn_fsync_active"
					}
				},
_EOF
			fi
		)
	]
}
EOF
