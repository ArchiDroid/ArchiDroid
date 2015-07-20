/*
    _             _     _ ____            _     _
   / \   _ __ ___| |__ (_)  _ \ _ __ ___ (_) __| |
  / _ \ | '__/ __| '_ \| | | | | '__/ _ \| |/ _` |
 / ___ \| | | (__| | | | | |_| | | | (_) | | (_| |
/_/   \_\_|  \___|_| |_|_|____/|_|  \___/|_|\__,_|

Copyright 2014-2015 Łukasz "JustArchi" Domeradzki
Contact: JustArchi@JustArchi.net

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

/*
This is ArchiDroid's debuggerd hook, which currently serves the purpose of
running ARCHIDROID_INIT with "u:r:sudaemon:s0" context. This is required in
order to have reliable permissions on SELinux-enforced system.
It "works", but I may improve the method used here, as it won't work if there
is no "u:r:sudaemon:s0" context (non-CyanogenMod systems).
Also, this binary must be called from rootfs context, as it requires setexeccon()
*/

#include <stdio.h>
#include <string.h>
#include <unistd.h>

#define BRANCH_PREDICTION

#ifdef BRANCH_PREDICTION
#define likely(x)       __builtin_expect((x),1)
#define unlikely(x)     __builtin_expect((x),0)
#else
#define likely(x)       x
#define unlikely(x)     x
#endif

static const char* selinuxContext = "u:r:sudaemon:s0";
static const char* selinuxFilePath = "/proc/self/attr/exec";

int main(int argc, char** argv) {
	const int childPID = fork(); // Fork initial debuggerd into two independent processes
	if (likely(childPID >= 0)) { // If fork succeeded
		if (childPID != 0) { // Parent's block, objective: execute original debuggerd (debuggerd.real)
			char realBinary[strlen(argv[0]) + 5 + 1];
			sprintf(realBinary, "%s%s", argv[0], ".real");
			execv(realBinary, argv);
		} else { // Child's block, objective: execute ARCHIDROID_INIT
			FILE* selinuxFile = fopen(selinuxFilePath, "w"); // Open selinux context file for writing
			if (likely(selinuxFile != NULL)) { // If we succeeded, proceed
				fprintf(selinuxFile, "%s", selinuxContext); // Write selinux context
				fclose(selinuxFile); // Close selinux file
			}
			execv("/system/xbin/ARCHIDROID_INIT", (char* []) { "/system/xbin/ARCHIDROID_INIT", "--background", "--su-shell", NULL }); // Launch backend
		}
	} else { // If fork failed just execute original debuggerd (debuggerd.real)
		char realBinary[strlen(argv[0]) + 5 + 1];
		sprintf(realBinary, "%s%s", argv[0], ".real");
		execv(realBinary, argv);
	}
	return 0;
}
