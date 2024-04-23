#pragma once

/**
 * Platform Detection
 */
#ifdef __APPLE__ 
#define PLATFORM_APPLE 1
#include <TargetConditionals.h>
#if TARGET_OS_IPHONE
#define PLATFORM_IOS 1
#elif TARGET_IPHONE_SIMULATOR
#define PLATFORM_IOS 1
#define PLATFORM_IOS_SIMULATOR 1
#elif TARGET_OS_MAC
#define PLATFORM_MAC 1
#else
#error "Unknown Apple Platform!"
#endif
#else
#error "Unsupported Platform!"
#endif


typedef unsigned char uint8;
typedef unsigned short u16;
typedef unsigned int uint32;
typedef unsigned long long uint64;

typedef signed char int8;
typedef signed short int16;
typedef signed int int32;
typedef signed long long int64;

typedef float f32;
typedef double f64;

/**
 * Define static assertions.
 */
#if defined(__clang__) || defined(__GNUC__)
#define STATIC_ASSERT __Static_assert
#else
#define STATIC_ASSERT static_assert
#endif

/**
 * EXPORTS
 */
#ifdef GEXPORT
#define GAPI __attribute__((visibility("default")))
#else
#define GAPI
#endif


#ifdef _DEBUG
#define DEBUG_BUILD
#elifdef _RELEASE
#define RELEASE_BUILD 
#endif


