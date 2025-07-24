#include "rtString.h"
#include <stdio.h>
#include <string.h>

#if 1
uint32_t rtString_Copy(char* dstBuffer, const char* srcBuffer, uint32_t dstBufferSize)
{
   if ((0 == dstBufferSize) || (!srcBuffer) || (!dstBuffer))
        return 0;

    int srcBufferSize = snprintf(dstBuffer, dstBufferSize, "%s", srcBuffer);

    if (srcBufferSize >= dstBufferSize)
        printf("Output was truncated.\n");

    if (dstBufferSize <= srcBufferSize)
        return dstBufferSize;
    else
        return srcBufferSize;
}
#else
uint32_t rtString_Copy(char* dest, const char* src, uint32_t size)
{
    if (!dest || !src) {
        return 0;
    }

    if (size == 0) {
        return 0;
    }

    return snprintf (dest, size, "%s", src);
}
#endif
