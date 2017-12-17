#include "hello.h"

int main(void) {
  printf("Hello, %F", powf(2, 45));
  pthread_t pt;
  pthread_create(&pt, NULL, &f, NULL);
  return 0;
}

