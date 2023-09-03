#pragma once

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CAMetalLayer.h>
#include <stdlib.h>

typedef struct GWindow GWindow;

@interface ApplicationDelegate: NSObject<NSApplicationDelegate>{}
-(instancetype)init;
//-(void)populateMainMenu;
@end

@interface WindowDelegate : NSWindow <NSWindowDelegate>
{
    GWindow* handle;
}
-(instancetype)initWithHandle:(GWindow*)windowHandle;

@end //interface WindowDelegate

typedef struct GWindow{
   NSWindow* window;
   CAMetalLayer* layer;
   ApplicationDelegate* app_delegate;
   WindowDelegate* window_delegate;
   bool should_close;
}GWindow;


GWindow* GWindow_Create(int width, int height, const char* title, int flags);

void GWindow_Poll_Events();

void GWindow_Destroy(GWindow* window);

bool GWindow_Should_Close(GWindow* window);


