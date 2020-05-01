#!/bin/bash
echo "-- C compilers available"
ls -1 /usr/bin/gcc*
ls -1 /usr/bin/clang*
ls -1 /usr/bin/scan-build*
echo "----"

echo "WORK DIR:$DIR"
DIR=$PWD

if [ "$TRAVIS_JOB_NAME" == "linux-mingw" ]; then
    echo "--> Building Release for Windows (x86-64) ..."
    mkdir -p build-mingw && cd build-mingw
    echo "-DCMAKE_SYSTEM_NAME=Windows -DTOOLCHAIN_PREFIX=x86_64-w64-mingw32 \
          -DCMAKE_TOOLCHAIN_FILE=$PWD/../cmake/modules/set_toolchain.cmake -DCMAKE_INSTALL_PREFIX=$PWD/_install $DIR"
    cmake -DCMAKE_SYSTEM_NAME=Windows -DTOOLCHAIN_PREFIX=x86_64-w64-mingw32 \
          -DCMAKE_TOOLCHAIN_FILE=$PWD/../cmake/modules/set_toolchain.cmake -DCMAKE_INSTALL_PREFIX=$PWD/_install $DIR
    make && cd -

    #elif [ "$TRAVIS_OS_NAME" == "linux" ] || [ condition ]; then                   ### TODO: Detect minGW
    #   echo "--> Building Release for Windows (i686) ..."
    #    mkdir -p build/Release-mingw32 && cd build/Release-mingw32
    #    echo "-DCMAKE_SYSTEM_NAME=Windows -DTOOLCHAIN_PREFIX=i686-w64-mingw32 \
    #          -DCMAKE_TOOLCHAIN_FILE=$PWD/cmake/modules/set_toolchain.cmake -DCMAKE_INSTALL_PREFIX=$PWD/_install $DIR"
    #    cmake -DCMAKE_SYSTEM_NAME=Windows -DTOOLCHAIN_PREFIX=i686-w64-mingw32 \
    #          -DCMAKE_TOOLCHAIN_FILE=$PWD/cmake/modules/set_toolchain.cmake -DCMAKE_INSTALL_PREFIX=$PWD/_install $DIR
    #    make

elif [ "$TRAVIS_OS_NAME" == "linux" ]; then
    sudo apt-get update -qq || true
    sudo apt-get install -qq -y --no-install-recommends libgtk-3-dev

    echo "--> Building Debug..."
    mkdir -p build/Debug && cd build/Debug
    echo "-DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=$PWD/_install"
    cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=$PWD/_install $DIR
    make && make package && cd -

    echo "--> Building Release..."
    mkdir -p build/Release && cd build/Release
    echo "-DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PWD/_install"
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PWD/_install $DIR
    make && make package && cd -

elif [ "$TRAVIS_OS_NAME" == "osx" ]; then
    brew install libusb

    echo "--> Building Debug..."
    mkdir -p build/Debug && cd build/Debug
    echo "-DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=$PWD/_install"
    cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=$PWD/_install $DIR
    make && make package && cd -

    echo "--> Building Release..."
    mkdir -p build/Release && cd build/Release
    echo "-DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PWD/_install"
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PWD/_install $DIR
    make && make package && cd -

else # local test-build
    echo "--> Building Debug..."
    mkdir -p build/Debug && cd build/Debug
    echo "-DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=$PWD/_install"
    cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=$PWD/_install ../../
    make && make package && cd -

    echo "--> Building Release..."
    mkdir -p build/Release && cd build/Release
    echo "-DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PWD/_install"
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PWD/_install ../../
    make && make package && cd -
fi
