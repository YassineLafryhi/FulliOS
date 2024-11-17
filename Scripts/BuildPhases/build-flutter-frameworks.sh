if [[ "$(uname -m)" == arm64 ]]
then
    export PATH="/opt/homebrew/bin:$PATH"
fi

FLUTTER_FRAMEWORK="$SRCROOT/Frameworks/Flutter.xcframework"
FLUTTER_MODULE="$SRCROOT/FlutterModule"

build_flutter_framework() {
    required_version="3.24.1"
    flutter_version=$(flutter --version 2>&1 | awk '/Flutter/ {print $2}')
    if [[ $(printf '%s\n' "$required_version" "$flutter_version" | sort -V | head -n1) != "$required_version" ]]; then
        echo "error: Flutter version $required_version or newer is required to build the frameworks."
        exit 1
    fi
    cd "$FLUTTER_MODULE"
    flutter build ios-framework --no-profile --no-release
    cp -r ./build/ios/framework/Debug/App.xcframework "$SRCROOT/Frameworks"
    cp -r ./build/ios/framework/Debug/Flutter.xcframework "$SRCROOT/Frameworks"
}

if [ ! -d "$FLUTTER_FRAMEWORK" ]; then
    build_flutter_framework
else
    changes=$(git -C "$SRCROOT" status --porcelain "$FLUTTER_MODULE")
    if [ ! -z "$changes" ]; then
        build_flutter_framework
    fi
fi
