C_LIBRARY="$SRCROOT/CLibrary"

build_c_library() {
    cd "$C_LIBRARY"
    clang -c -arch arm64 -isysroot $(xcrun --sdk iphoneos --show-sdk-path) fourier.c -o fourier.o
    ar rcs libc.a fourier.o
    rm fourier.o
    cp libc.a "$SRCROOT/StaticLibs/libc.a"
}

if [ ! -d "$SRCROOT/StaticLibs/libc.a" ]; then
    build_c_library
else
    changes=$(git -C "$SRCROOT" status --porcelain "$RUST_LIBRARY")
    if [ ! -z "$changes" ]; then
        build_c_library
    fi
fi
