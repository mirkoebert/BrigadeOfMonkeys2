#!/bin/bash

os=`uname`
if [[ "$os" == 'Linux' ]]; then
    core=`nproc`
elif [[ "$os" == 'Darwin' ]]; then
    core=`sysctl -n hw.ncpu`
else
    echo "Error: Unsupported platform: $os"
    exit
fi
echo $core
