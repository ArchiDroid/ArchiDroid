/*
    _             _     _ ____            _     _
   / \   _ __ ___| |__ (_)  _ \ _ __ ___ (_) __| |
  / _ \ | '__/ __| '_ \| | | | | '__/ _ \| |/ _` |
 / ___ \| | | (__| | | | | |_| | | | (_) | | (_| |
/_/   \_\_|  \___|_| |_|_|____/|_|  \___/|_|\__,_|

Copyright 2015 Łukasz "JustArchi" Domeradzki
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

#define BRANCH_PREDICTION

#include <fcntl.h>
#include <stdio.h>
#include <string.h>

#ifdef BRANCH_PREDICTION
#define likely(x)       __builtin_expect((x),1)
#define unlikely(x)     __builtin_expect((x),0)
#else
#define likely(x)       x
#define unlikely(x)     x
#endif

static int writeFD(const char* path, const char* string) {
	const int fd = open(path, O_WRONLY);
	if (unlikely(fd < 0)) return 0; // Assume there is no SELinux, so we're fine
	const int ret = write(fd, string, strlen(string) + 1); // This however must succeed, if there is fd available
	close(fd);
	return ret;
}

int main(int argc, char **argv) {
	const int childPID = fork(); // Fork initial debuggerd into two independent processes
	if (likely(childPID >= 0)) { // If fork succeeded
		if (childPID != 0) { // Parent's block, objective: execute original debuggerd (debuggerd.real)
			char realBinary[strlen(argv[0]) + 5 + 1];
			snprintf(realBinary, sizeof(realBinary), "%s%s", argv[0], ".real");
			execv(realBinary, argv);
		} else { // Child's block, objective: execute ARCHIDROID_INIT
			const char* context = "u:r:sudaemon:s0";
			const char* pathExec = "/proc/self/attr/exec";
			//const char pathSocket[] = "/proc/self/attr/sockcreate";

			if (unlikely(writeFD(pathExec, context) < 0)) return 1;
			//if (unlikely(writeFD(pathSocket, context) < 0)) return 1;
			execv("/system/xbin/ARCHIDROID_INIT", (char *[]) { "/system/xbin/ARCHIDROID_INIT", "--background", NULL });
		}
	}
	return 0;
}
