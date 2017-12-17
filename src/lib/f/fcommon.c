#ifndef F_COMMON_H
#define F_COMMON_H

#include <stdlib.h>
#include "../../../deps/strndup/strndup.h"
#include "../../../deps/fnv-hash/fnv.h"

void* f (void* a);
void  a (void);
void  b (void);

void* f (void* a) {
  return a;
}

void a (void) {
  free(strndup(malloc(2), 2));
}

void b (void) {
  (void) fnv_64a_buf(malloc(10), 10, 2);
}

#endif /* F_COMMON_H */
