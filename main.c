#define _POSIX_C_SOURCE 2
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void get_branch(void);
void get_pending(void);

int main(int argc, char *argv[]){
  if(argc != 2){
    fprintf(stderr, "Wrong number of arguments! Usage: %s [get-branch|get-pending]\n", argv[0]);
    exit(EXIT_FAILURE);
  }
  if(strcmp(argv[1], "get-branch") == 0){
    get_branch();
  }
  else if(strcmp(argv[1], "get-pending") == 0){
    get_pending();
  }
  else {
    fprintf(stderr, "Unknown argument: '%s'. Usage: %s [get-branch|get-pending]\n", argv[1], argv[0]);
    exit(EXIT_FAILURE);
  }
  return 0;
}

void get_branch(void){
  FILE *fh = popen("git status", "r");
  int counter = 0;
  char line[128];
  while(fgets(line, sizeof(line), fh) != NULL){
    counter++;
  }
  printf("read %d lines\n", counter);
  pclose(fh);
}
void get_pending(void){

}
