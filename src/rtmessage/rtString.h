#ifndef RT_STRING_H
#define RT_STRING_H

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

// Safe string copy: copies up to (size-1) characters and null-terminates
void rtString_Copy(char* dest, const char* src, uint32_t size);

#ifdef __cplusplus
}
#endif
#endif // RT_STRING_H
