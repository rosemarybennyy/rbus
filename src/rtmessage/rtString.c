#include "rtString.h"
#include <stdlib.h>
#include <string.h>

uint32_t rtString_Copy(char* dest, const char* src, uint32_t size)
{
    if (!dest || !src) {
        return 0;
    }

    if (size == 0) {
        return 0;
    }

    int written = snprintf(dest, size, "%s", src);

    if (written >= (int)size) {
        dest[size - 1] = '\0'; 
        return size - 1;       
    }

    return (uint32_t)written;
}
