#!/bin/sh

rm hijack.dll
i686-w64-mingw32-gcc hijack.c -o hijack.dll -shared
file hijack.dll
