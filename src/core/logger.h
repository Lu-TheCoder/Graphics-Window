#pragma once
#include "../defines.h"

#ifdef RELEASE_BUILD
#define LOG_INFO_ENABLED 1
#define LOG_WARN_ENABLED 1
//Disable DEBUG and TRACE logging for release builds.
#define LOG_DEBUG_ENABLED 0
#define LOG_TRACE_ENABLED 0
#else
#define LOG_WARN_ENABLED 1
#define LOG_INFO_ENABLED 1
#define LOG_DEBUG_ENABLED 1
#define LOG_TRACE_ENABLED 1
#endif

typedef enum log_level {
    LOG_LEVEL_FATAL = 0,
    LOG_LEVEL_ERROR = 1,
    LOG_LEVEL_WARN  = 2,
    LOG_LEVEL_INFO  = 3,
    LOG_LEVEL_DEBUG = 4,
    LOG_LEVEL_TRACE = 5,
}log_level;

/**
 * @brief Logs output formatted for a given log_level.
 * 
 * @param level The log level to use.
 * @param message The message to be logged to the console.
 * @param ... Any other formatted data that should be included in the log entry.
 */
GAPI void log_output(log_level level, const char* message, ...);

#define LFATAL(message, ...) log_output(LOG_LEVEL_FATAL, message, ##__VA_ARGS__);
#define LERROR(message, ...) log_output(LOG_LEVEL_ERROR, message, ##__VA_ARGS__);

#if LOG_WARN_ENABLED == 1
#define LWARN(message, ...)  log_output(LOG_LEVEL_WARN,  message, ##__VA_ARGS__);
#else
#define LWARN(message, ...)
#endif

#if LOG_INFO_ENABLED == 1
#define LINFO(message, ...)  log_output(LOG_LEVEL_INFO,  message, ##__VA_ARGS__);
#else
#define LINFO(message, ...)
#endif

#if LOG_DEBUG_ENABLED == 1
#define LDEBUG(message, ...) log_output(LOG_LEVEL_DEBUG, message, ##__VA_ARGS__);
#else
#define LDEBUG(message, ...)
#endif

#if LOG_TRACE_ENABLED == 1
#define LTRACE(message, ...) log_output(LOG_LEVEL_TRACE, message, ##__VA_ARGS__);
#else
#define LTRACE(message, ...)
#endif