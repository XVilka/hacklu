#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <regex.h>
#include <stdint.h>

int is_libc_line(char* line) {
	regex_t regex;
	int ret;
	int reti;
	char msgbuf[100];

	/* Compile regular expression */
	reti = regcomp(&regex, "libc-[[:digit:]].[[:digit:]][[:digit:]].so", 0);
	if( reti ){ fprintf(stderr, "Could not compile regex\n"); exit(1); }

	/* Execute regular expression */
	reti = regexec(&regex, line, 0, NULL, 0);
	if( !reti ){
		ret = 1;
	}
	else if( reti == REG_NOMATCH ){
		ret = 0;
	}
	else{
		regerror(reti, &regex, msgbuf, sizeof(msgbuf));
		fprintf(stderr, "Regex match failed: %s\n", msgbuf);
		exit(1);
	}
	/* Free compiled regular expression if you want to use the regex_t again */
	regfree(&regex);

	return ret;
}

intptr_t get_base_addr() {
	FILE * fp;
	char * line = NULL;
	size_t len = 0;
	ssize_t read;
	int matched = 0;
	intptr_t libc_base = 0;

	fp = fopen("/proc/self/maps", "r");
	if (fp == NULL)
		exit(EXIT_FAILURE);

	while ((read = getline(&line, &len, fp)) != -1) {
		matched = is_libc_line (line);
		if (matched) {
			libc_base = strtoull(line, NULL, 16);
			break;
		}
	}

	fclose(fp);
	if (line) free(line);
	return libc_base;
}

int main(int argc, char** argv) {
	setvbuf(stdout, NULL, _IONBF, 0);
	intptr_t libc_base = get_base_addr ();
	printf("libc base addr - %p\n", (void*)libc_base);
	unsigned long long input_value;
	printf("where should I jump to? ");
	scanf("%llu", &input_value);
	void (*func_ptr)(void) = (void (*)(void))input_value;
	asm __volatile__ ("xor %rsi, %rsi;");
	asm __volatile__ ("push %rsi");
	func_ptr();
}
