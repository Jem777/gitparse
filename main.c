#define _POSIX_C_SOURCE 2
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <dirent.h>

#define DT_DIR 4

void get_branch(void);
int get_pending(void);
int get_dirlisting(int *files, int *dirs);

int main(int argc, char *argv[]){
  if(argc != 2){
    fprintf(stderr, "Wrong number of arguments! Usage: %s [get-branch|get-pending|get-dir]\n", argv[0]);
    exit(EXIT_FAILURE);
  }
  if(strcmp(argv[1], "get-branch") == 0){
    get_branch();
  }
  else if(strcmp(argv[1], "get-pending") == 0){
    int pending = get_pending();
    if(pending > 0){
      printf("%%B(%d)%%b\n", pending);
    }
  }
  else if(strcmp(argv[1], "get-dir") == 0){
    int files;
    int dirs;
    if(get_dirlisting(&files, &dirs)){
      printf("%d/%d\n", files, dirs);
    }
  }
  else {
    fprintf(stderr, "Unknown argument: '%s'. Usage: %s [get-branch|get-pending|get-dir]\n", argv[1], argv[0]);
    exit(EXIT_FAILURE);
  }
  return 0;
}

int get_pending(void){
  FILE *fh = popen("git status", "r");
  int counter = 0;
  char line[128];
  while(fgets(line, sizeof(line), fh) != NULL){
    if(strstr(line, "modified:") != 0)
      counter++;
  }
  pclose(fh);
  return counter;
}
void get_branch(void){
  FILE *fh = popen("git branch", "r");
  char line[128];
  while(fgets(line, sizeof(line), fh) != NULL){
    if(line[0] == 42)
      break;
  }
  size_t length = strlen(line);
  line[length-1] = 0;
  printf("%%B%s%%b \n", line+2);
}

int get_dirlisting(int *files, int *dirs){
  DIR *dp;
  struct dirent *ep;     
  dp = opendir ("./");
  
  if (dp != NULL)
    {
      int filecount = 0;
      int dircount = 0;
      while ((ep = readdir (dp))){
	if(ep->d_type == DT_DIR){
	  dircount++;
	}
	else {
	  filecount++;
	}
      }
      closedir(dp);
      *files = filecount;
      *dirs = dircount;
      return 1;
    }
  return 0;
}
