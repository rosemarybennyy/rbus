#include "rtString.h"
#include <stdio.h>
#include <string.h>

#if 0
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
#endif

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

