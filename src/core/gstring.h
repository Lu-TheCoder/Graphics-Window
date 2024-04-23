#pragma once
#include "../defines.h"

int32 string_format(char* dest, const char* format, ...);

int32 string_format_v(char* dest, const char* format, void* va_listp);