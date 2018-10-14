
#define _GNU_SOURCE

#include <string.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/utsname.h>
#include <unistd.h>
#include <pthread.h>

void *thread(void *p) {
	printf("Hello\n");
}

int main(int argc, char *argv[]) {
	int fd;
	pthread_t t;
	
	pthread_create(&t, NULL, thread, NULL);
	return 0;	
}
