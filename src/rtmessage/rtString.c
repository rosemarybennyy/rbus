#include "rtString.h"
#include <string.h>

uint32_t rtString_Copy(char* dest, const char* src, uint32_t size)
{
    if (!dest || !src) {
        return 0;
    }

    if (size == 0) {
        return 0;
    }

    return (uint32_t)snprintf(dest, size, "%s", src);
}
