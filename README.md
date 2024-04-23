# Custom GLFW inspired Window Platform Layer.
 
This is my very own attempt at implementing my own Custom Windows Platform Layer for Graphics Rendering.

This window can be used for Game Engines or custom games that dont rely on GLFW.

<img width="669" alt="window" src="https://github.com/Lu-TheCoder/Graphics-Window/assets/90724319/7d04ba42-5b28-40f0-ba8a-40cd04313993">


## Goal
The goal with this project was to build a base implementation that can be easily built upon and extended to suit the needs of your rendering projects on MacOS.

# How to Run
This Project is meant to run only on MacOS.

### Prerequisites:

Make sure vulkan is installed on your system and that the enivironmental variable `$VULKAN_SDK` points to where the SDK is installed.

### Build instructions:

open terminal in the project directory and run the following commands:

- For debug build:
`sh build-debug.sh`

- For release build:
`sh build-release.sh`
