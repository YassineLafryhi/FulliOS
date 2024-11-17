RUST_LIBRARY="$SRCROOT/RustLibrary"

build_rust_library() {
    rustup default stable
    rustup target add aarch64-apple-ios
    cd "$RUST_LIBRARY"
    export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
    cargo build --release --target aarch64-apple-ios
    cp  ./target/aarch64-apple-ios/release/libtextanalyzer.a "$SRCROOT/StaticLibs/librust.a"
}

if [ ! -d "$SRCROOT/StaticLibs/librust.a" ]; then
    build_rust_library
else
    changes=$(git -C "$SRCROOT" status --porcelain "$RUST_LIBRARY")
    if [ ! -z "$changes" ]; then
        build_rust_library
    fi
fi
