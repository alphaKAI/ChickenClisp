#include <stdlib.h>
#include <stdio.h>

typedef struct S {
  char* name;
  int age;
} S;

S* newS(char* name, int age) {
  S* ret = malloc(sizeof(S));

  ret->name = name;
  ret->age = age;

  return ret;
}

void showS(S* s) {
  printf("s->name : %s\n", s->name);
  printf("s->age : %d\n", s->age);
}
