#ifndef F_COMMON_H
#define F_COMMON_H

#include <stdlib.h>
#include "../../../deps/strndup/strndup.h"

void* f (void* a );
void   a (void);

void* f (void* a ) {
  return a;
}

void a (void) {
  free(strndup(malloc(2), 2));
}

#endif /* F_COMMON_H */
