#include <criterion/criterion.h>
#include "../hello.h"

Test(hello, f) {
  cr_assert_eq(NULL, f(NULL) );
}
