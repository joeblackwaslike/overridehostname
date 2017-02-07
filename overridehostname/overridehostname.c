#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <netinet/in.h>
#include <net/if.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <dlfcn.h>
#include <regex.h>

typedef int (*gethostname_t)(char *name, size_t len);
typedef int (*sethostname_t)(const char *name, size_t len);

gethostname_t old_gethostname;
sethostname_t old_sethostname;


size_t fh_strlcpy(char *dst, const char *src, size_t dstsize){
  size_t len = strlen(src);
  if(dstsize) {
    size_t bl = (len < dstsize-1 ? len : dstsize-1);
    ((char*)memcpy(dst, src, bl))[bl] = 0;
  }
  return len;
}

void strip_substring(char *string, char *toremove) {
  while(string=strstr(string, toremove))
    memmove(string, string+strlen(toremove), 1+strlen(string+strlen(toremove)));
}

int fh_get_hostname(char *name, size_t len){
    int rc = 0;
    FILE *fd = fopen("/etc/hostname", "r");
    if (fd == NULL) {
        rc = 1;
    } else {
        fgets(name, len, fd);
        fclose(fd);
        strip_substring(name, "\n");
    }
    return rc;
}

int fh_set_hostname(char *name, size_t len){
    int rc = 0;
    FILE *fd = fopen("/etc/hostname", "w");
    if(fd == NULL) {
        rc = 1;
    } else {
        strip_substring(name, "\n");
        strcat(name, "\n");
        if (fputs(name, fd) != EOF) {
            rc = 1;
        }
        fclose(fd);
    }
    return rc;
}

void do_gethostname_redirect() {
	void *libc;
	char *error;

	if (!(libc = dlopen("libc.so.6", RTLD_LAZY))) {
		fprintf(stderr, "Cannot open libc.so.6: %s\n", dlerror());
		exit(1);
	}

	old_gethostname = dlsym(libc, "gethostname");

	if ((error = dlerror()) != NULL) {
		fprintf(stderr, "%s\n", error);
		exit(1);
	}
}

void do_sethostname_redirect() {
	void *libc;
	char *error;

	if (!(libc = dlopen("libc.so.6", RTLD_LAZY))) {
		fprintf(stderr, "Cannot open libc.so.6: %s\n", dlerror());
		exit(1);
	}

	old_sethostname = dlsym(libc, "sethostname");

	if ((error = dlerror()) != NULL) {
		fprintf(stderr, "%s\n", error);
		exit(1);
	}
}

int gethostname(char *name, size_t len) {
    int rc = 0;

	if (!old_gethostname)
		do_gethostname_redirect();

	if (getenv("OVERRIDE_HOSTNAME")) {
        rc = fh_get_hostname(name, len);
    } else {
        rc = old_gethostname(name, len);
    }
	return rc;
}

int sethostname(const char *name, size_t len) {
    int rc = 0;

    if (!old_sethostname)
		do_sethostname_redirect();

	if (getenv("OVERRIDE_HOSTNAME")) {
        rc = fh_set_hostname(name, len);
    } else {
        rc = old_sethostname(name, len);
    }
	return rc;
}
