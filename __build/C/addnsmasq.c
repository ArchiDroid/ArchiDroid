/*
    _             _     _ ____            _     _
   / \   _ __ ___| |__ (_)  _ \ _ __ ___ (_) __| |
  / _ \ | '__/ __| '_ \| | | | | '__/ _ \| |/ _` |
 / ___ \| | | (__| | | | | |_| | | | (_) | | (_| |
/_/   \_\_|  \___|_| |_|_|____/|_|  \___/|_|\__,_|

Copyright 2014-2016 Łukasz "JustArchi" Domeradzki
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
This is ArchiDroid's dnsmasq hook, which currently serves the purpose of
disabling ArchiDroid's Adblock prior to activating USB/Wi-Fi tethering.

This is done through informing the backend about ongoing tethering event.
*/

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>

#define BRANCH_PREDICTION

#ifdef BRANCH_PREDICTION
#define likely(x)       __builtin_expect((x),1)
#define unlikely(x)     __builtin_expect((x),0)
#else
#define likely(x)       x
#define unlikely(x)     x
#endif

static const char* eventDirPath = "/dev/archidroid/events";
static const char* eventFilePath = "/dev/archidroid/events/tethering";
static const unsigned int delay = 2; // Specifies minimum time we need to wait for backend's reaction

int main(int argc, char** argv) {
	struct stat st = {0};
	if (stat(eventDirPath, &st) != -1) { // If events dir exists
		remove(eventFilePath); // Make sure our event doesn't exist yet
		FILE* eventFile = fopen(eventFilePath, "w"); // Create event file for writing
		if (likely(eventFile != NULL)) { // If we succeeded, proceed
			fprintf(eventFile, "%s%u\n", "TETHERING ", getpid()); // Write event content - notify event listener about ongoing tethering with our PID
			fclose(eventFile); // Close event file
			sleep(delay); // Wait for backend's reaction
		}
	}
	char realBinary[strlen(argv[0]) + 5 + 1];
	sprintf(realBinary, "%s%s", argv[0], ".real");
	execv(realBinary, argv);
	return 0;
}
