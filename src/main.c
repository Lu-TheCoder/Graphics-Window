#include <stdio.h>
#include "platform/platform.h"
#include "renderer/renderer.h"

int main(){

    GWindow* window = GWindow_Create(600, 400, "My Window", 0);

    renderer_init(window);

    while(!GWindow_Should_Close(window)){

        renderer_draw(window);

        GWindow_Poll_Events();
    }

    GWindow_Destroy(window);
    
    return 0;
}