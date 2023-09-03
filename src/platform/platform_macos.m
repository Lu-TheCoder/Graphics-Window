#import <Foundation/Foundation.h>
#import "platform.h"
#include <stdlib.h>
#include <string.h>

@class ApplicationDelegate;
@class WindowDelegate;

GWindow* GWindow_Create(int width, int height, const char* title, int flags){
    GWindow* window = (GWindow*)malloc(sizeof(GWindow));
    memset(window, 0, sizeof(GWindow));

    @autoreleasepool {

        [NSApplication sharedApplication];
        [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
        [NSApp activateIgnoringOtherApps:YES];
        
        window->app_delegate = [ApplicationDelegate new];
        [NSApp setDelegate: window->app_delegate];
        
        window->window_delegate = [[WindowDelegate alloc] initWithHandle:window];
        
        NSRect screenRect = [NSScreen mainScreen].frame;
        NSRect initialFrame = NSMakeRect((screenRect.size.width - width) * 0.5f,
                                        (screenRect.size.height - height) * 0.5f,
                                        width, height);
        
        NSWindowStyleMask windowStyleMask = (NSWindowStyleMaskTitled |
                                            NSWindowStyleMaskClosable |
                                            NSWindowStyleMaskMiniaturizable |
                                            NSWindowStyleMaskResizable);
        
        
        window->window = [[NSWindow alloc] initWithContentRect:initialFrame
                                                    styleMask:windowStyleMask
                                                    backing:NSBackingStoreBuffered
                                                        defer:NO];
        
        [window->window setBackgroundColor: NSColor.redColor];
        [window->window setTitle: @(title)];
        [window->window setDelegate:window->window_delegate];
        [window->window.contentView setWantsLayer: YES];
        [window->window setAcceptsMouseMovedEvents: YES];
        [window->window setRestorable:NO];
        [window->window setLevel:NSNormalWindowLevel];
        [window->window makeKeyAndOrderFront: nil];
        
        [NSApp finishLaunching];
    
    } //autorelease

    return window;
}

void GWindow_Poll_Events(){
    @autoreleasepool {

        for(;;)
        {
            NSEvent* event = [NSApp nextEventMatchingMask:NSEventMaskAny
                                                untilDate:[NSDate distantPast]
                                                    inMode:NSDefaultRunLoopMode
                                                    dequeue:YES];
            if (event == nil)
            {
                break;
            }

            [NSApp sendEvent:event];
        }

    }	//autoreleasepool
}

void GWindow_Destroy(GWindow* window){

}

bool GWindow_Should_Close(GWindow* window){
    return window->should_close;
}



