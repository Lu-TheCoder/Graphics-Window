#!/bin/bash

# Convenience build script for Linux and MacOS.
OS=$(uname -s)

if [[ $OS == 'Darwin' ]]
then
    echo "Building for macOS..."
    ./build-all.sh macos build debug
fi
