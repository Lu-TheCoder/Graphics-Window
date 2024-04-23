#include "gstring.h"
#include <stdarg.h>
#include <string.h>
#include <stdio.h>

int32 string_format(char* dest, const char* format, ...) {
    if (dest) {
        __builtin_va_list arg_ptr;
        va_start(arg_ptr, format);
        int32 written = string_format_v(dest, format, arg_ptr);
        va_end(arg_ptr);
        return written;
    }
    return -1;
}

int32 string_format_v(char* dest, const char* format, void* va_listp){
    if (dest) {
        // Big, but can fit on the stack.
        char buffer[32000];
        int32 written = vsnprintf(buffer, 32000, format, va_listp);
        buffer[written] = 0;
        memcpy(dest, buffer, written + 1);

        return written;
    }
    return -1;
}