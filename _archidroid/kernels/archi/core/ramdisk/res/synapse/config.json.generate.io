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
			STitleBar:{
				title:"Internal SD Card (eMMC)"
			}
		},
		{
			SOptionList:{
				title:"Internal storage scheduler",
				description:"The selected scheduling algorithm decides which order block I/O operations will be submitted to storage volumes.",
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
			SSeekBar:{
				title:"Internal storage read-ahead",
				description:"This setting controls how much extra data the operating system reads from disk when performing I/O operations.",
				max:2048, min:128, unit:" kB", step:128,
				default:$(AK_generic /sys/block/mmcblk0/queue/read_ahead_kb),
				action:"AK_generic /sys/block/mmcblk0/queue/read_ahead_kb"
			}
		},
		{
			SCheckBox:{
				label:"Entropy collection from internal storage I/O operations",
				description:"By default, the amount of time to write a block is used as source of entropy. This behaviour can be disabled in order to improve I/O speed for the cost of potential lower kernel's entropy pool",
				default:$(AK_generic /sys/block/mmcblk0/queue/add_random),
				action:"AK_generic /sys/block/mmcblk0/queue/add_random"
			}
		},
		$(
			if [[ -e /sys/block/mmcblk1 ]]; then
cat << _EOF
				{
					STitleBar:{
						title:"External SD Card"
					}
				},
				{
					SOptionList:{
						title:"External storage scheduler",
						description:"The selected scheduling algorithm decides which order block I/O operations will be submitted to storage volumes.",
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
						title:"External storage read-ahead",
						description:"This setting controls how much extra data the operating system reads from disk when performing I/O operations.",
						max:2048, min:128, unit:" kB", step:128,
						default:$(AK_generic /sys/block/mmcblk1/queue/read_ahead_kb),
						action:"AK_generic /sys/block/mmcblk1/queue/read_ahead_kb"
					}
				},
				{
					SCheckBox:{
						label:"Entropy collection from external storage I/O operations",
						description:"By default, the amount of time to write a block is used as source of entropy. This behaviour can be disabled in order to improve I/O speed for the cost of potential lower kernel's entropy pool",
						default:$(AK_generic /sys/block/mmcblk1/queue/add_random),
						action:"AK_generic /sys/block/mmcblk1/queue/add_random"
					}
				},
_EOF
			fi
		)
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
