#import "renderer.h"
#include <Cocoa/Cocoa.h>
#include <Metal/Metal.h>
#include <QuartzCore/CAMetalLayer.h>
#include "shaderInterface.h"
#include "core/logger.h"

static id<MTLDevice> mtlDevice;
static id<MTLCommandQueue> mtlCommandQueue;
static id<MTLBuffer> vertexBuffer;
static id<MTLRenderPipelineState> mtlRenderPipelineState;

static GWindow* _window;

void renderer_init(GWindow* window){

    _window = window;

    mtlDevice = MTLCreateSystemDefaultDevice();
    LINFO("GPU: %s", mtlDevice.name.UTF8String);

    mtlCommandQueue = [mtlDevice newCommandQueue];

    // Create CAMetalLayer and add to mainWindow
    window->layer = [CAMetalLayer new];
    window->layer.frame = window->window.contentView.frame;
    window->layer.device = mtlDevice;
    window->layer.pixelFormat = MTLPixelFormatBGRA8Unorm;
    
    window->layer.bounds = window->window.contentView.bounds;
    window->layer.drawableSize = [window->window.contentView convertSizeToBacking:window->window.contentView.bounds.size];
    window->layer.contentsScale = window->window.contentView.window.backingScaleFactor;
    
    [window->window.contentView.layer addSublayer:window->layer];

    [[NSFileManager defaultManager] changeCurrentDirectoryPath:[NSBundle mainBundle].bundlePath];

    // Load shaders
    NSError* error = nil;
    NSURL* path = [NSURL fileURLWithPath:@"shaders.metallib" isDirectory:false];
    id<MTLLibrary> mtlLibrary = [mtlDevice newLibraryWithURL: path error:&error];
    if (!mtlLibrary) {
        printf("Failed to load library. Error: %s\n", error.localizedDescription.UTF8String);
    }
    id<MTLFunction> vertFunc = [mtlLibrary newFunctionWithName:@"vert"];
    id<MTLFunction> fragFunc = [mtlLibrary newFunctionWithName:@"frag"];
    [mtlLibrary release];

    // Create Vertex Buffer
    float vertexData[] = { // x, y, r, g, b, a
         0.5f, -0.5f, 1.f, 0.5f, 1.f, 1.f,
         0.5f,  0.5f, 0.f, 1.f, 0.f, 1.f,
        -0.5f, -0.5f, 0.f, 0.f, 1.f, 1.f,

        -0.5f, -0.5f, 0.f, 0.f, 1.f, 1.f,
        -0.5f,  0.5f, 0.f, 1.f, 0.f, 1.f,
        0.5f,  0.5f, 0.f, 1.f, 0.f, 1.f,

    };

    vertexBuffer = [mtlDevice newBufferWithBytes:vertexData length:sizeof(vertexData)
                                            options:MTLResourceStorageModePrivate];


    // Create vertex descriptor
    MTLVertexDescriptor* vertDesc = [MTLVertexDescriptor new];
    vertDesc.attributes[VertexAttributeIndex_Position].format = MTLVertexFormatFloat2;
    vertDesc.attributes[VertexAttributeIndex_Position].offset = 0;
    vertDesc.attributes[VertexAttributeIndex_Position].bufferIndex = VertexBufferIndex_Attributes;
    vertDesc.attributes[VertexAttributeIndex_Color].format = MTLVertexFormatFloat4;
    vertDesc.attributes[VertexAttributeIndex_Color].offset = 2 * sizeof(float);
    vertDesc.attributes[VertexAttributeIndex_Color].bufferIndex = VertexBufferIndex_Attributes;
    vertDesc.layouts[VertexBufferIndex_Attributes].stride = 6 * sizeof(float);
    vertDesc.layouts[VertexBufferIndex_Attributes].stepRate = 1;
    vertDesc.layouts[VertexBufferIndex_Attributes].stepFunction = MTLVertexStepFunctionPerVertex;

    // Create Render Pipeline State
    MTLRenderPipelineDescriptor* mtlRenderPipelineDesc = [MTLRenderPipelineDescriptor new];
    mtlRenderPipelineDesc.vertexFunction = vertFunc;
    mtlRenderPipelineDesc.fragmentFunction = fragFunc;
    mtlRenderPipelineDesc.vertexDescriptor = vertDesc;
    mtlRenderPipelineDesc.colorAttachments[0].pixelFormat = window->layer.pixelFormat;
    mtlRenderPipelineState = [mtlDevice newRenderPipelineStateWithDescriptor:mtlRenderPipelineDesc error:&error];
    if (!mtlRenderPipelineState) {
        printf("Failed to create pipeline state. Error: %s\n", error.localizedDescription.UTF8String);
    }

    [vertFunc release];
    [fragFunc release];
    [vertDesc release];
    [mtlRenderPipelineDesc release];


}

void renderer_draw(){

    @autoreleasepool {
        id<CAMetalDrawable> drawable = [_window->layer nextDrawable];

        if(drawable) {
            MTLRenderPassDescriptor* mtlRenderPassDescriptor = [MTLRenderPassDescriptor new];
            mtlRenderPassDescriptor.colorAttachments[0].texture = drawable.texture;
            mtlRenderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
            mtlRenderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
            mtlRenderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.1, 0.1, 0.1, 1.0);

            id<MTLCommandBuffer> mtlCommandBuffer = [mtlCommandQueue commandBuffer];

            id<MTLRenderCommandEncoder> mtlRenderCommandEncoder = [mtlCommandBuffer renderCommandEncoderWithDescriptor:mtlRenderPassDescriptor];
            [mtlRenderPassDescriptor release];

            //Drawing
            [mtlRenderCommandEncoder setViewport:(MTLViewport){0, 0,
                                                                    _window->layer.drawableSize.width,
                                                                    _window->layer.drawableSize.height,
                                                                    0, 1}];
            [mtlRenderCommandEncoder setRenderPipelineState:mtlRenderPipelineState];
            [mtlRenderCommandEncoder setVertexBuffer:vertexBuffer offset:0 atIndex:VertexBufferIndex_Attributes];
            [mtlRenderCommandEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:6];
            //endDrawing


            [mtlRenderCommandEncoder endEncoding];

            [mtlCommandBuffer presentDrawable:drawable];
            [mtlCommandBuffer commit];
        }
    }
}

void renderer_destroy(){
    
}