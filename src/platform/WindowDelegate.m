#import <Foundation/Foundation.h>
#import "platform.h"

@implementation WindowDelegate


- (instancetype)initWithHandle:(GWindow *)windowHandle{

    self = [super init];
    
    if(self != nil){
        handle = windowHandle;
        handle->should_close = false;
    }
    
    return self;
}

- (BOOL)windowShouldClose:(NSWindow *)sender {
    handle->should_close = true;
    return YES;
}

- (void)windowDidResize:(NSNotification *)notification
{
    NSLog(@"Did Resize");
}

- (void)windowDidMiniaturize:(NSNotification *)notification
{
    
}

- (void)windowDidDeminiaturize:(NSNotification *)notification
{
    
}

@end