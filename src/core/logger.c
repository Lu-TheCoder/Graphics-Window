#include "logger.h"
#include <string.h>
#include "gstring.h"
#include <stdarg.h>
#include <stdio.h>

void log_output(log_level level, const char* message, ...){
    const char* level_strings[6] = {"[FATAL]: ", "[ERROR]: ", "[WARN]:  ", "[INFO]:  ", "[DEBUG]: ", "[TRACE]: "};
    bool is_error = level < LOG_LEVEL_WARN;

    char out_message[32000];
    memset(out_message, 0, sizeof(out_message));

    __builtin_va_list arg_ptr;
    va_start(arg_ptr, message);
    string_format_v(out_message, message, arg_ptr);
    va_end(arg_ptr);

    // Prepend log level to message.
    string_format(out_message, "%s%s\n", level_strings[level], out_message);

    // Print accordingly
    if (is_error) {
         const char* colour_strings[] = {"0;41", "1;31", "1;33", "1;32", "1;34", "1;30"};
        printf("\033[%sm%s\033[0m", colour_strings[level], out_message);
    } else {
        const char* colour_strings[] = {"0;41", "1;31", "1;33", "1;32", "1;34", "1;30"};
        printf("\033[%sm%s\033[0m", colour_strings[level], out_message);
    }

}