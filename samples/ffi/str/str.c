#include <string.h>
#include <stdlib.h>
#include <stdio.h>

char* dub(char* str) {
  size_t len = strlen(str) * 2 + 1;
  char* s = malloc(sizeof(char) * len);
  sprintf(s, "%s%s", str, str);
  s[len - 1] = '\0';
  return s;
}
