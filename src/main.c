#include <stdio.h>
#include "platform/platform.h"
#include "renderer/renderer.h"

int main(){

    GWindow* window = GWindow_Create(600, 400, "My Graphics Engine (Metal)", 0);

    renderer_init(window);

    while(!GWindow_Should_Close(window)){

        renderer_draw();

        GWindow_Poll_Events();
    }

    renderer_destroy();
    GWindow_Destroy(window);
    
    return 0;
}