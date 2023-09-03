#include <stdio.h>
#include "platform/platform.h"

int main(){

    GWindow* window = GWindow_Create(400, 600, "My Window", 0);

    while(!GWindow_Should_Close(window)){

        GWindow_Poll_Events();
    }

    GWindow_Destroy(window);
    
    return 0;
}