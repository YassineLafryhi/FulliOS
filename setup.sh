# Check for required tools
if ! command -v tuist &> /dev/null
then
    echo "Tuist is required to build this project. Please install it using 'brew install tuist/tap/tuist' or visit https://tuist.io for more information."
    exit 1
fi

if ! command -v pod &> /dev/null
then
    echo "CocoaPods is required to build this project. Please install it using 'brew install cocoapods' or visit https://cocoapods.org for more information."
    exit 1
fi

# Flutter
if ! command -v flutter &> /dev/null
then
    echo "Flutter is required to build this project. Please install it using 'brew install flutter' or visit https://flutter.dev for more information."
    exit 1
fi

SRCROOT=$(pwd)
PODS_ROOT=$SRCROOT/Pods
export SRCROOT
export PODS_ROOT

mkdir -p $SRCROOT/Frameworks
mkdir -p $SRCROOT/FulliOS/Sources/Generated

# Build Flutter xcframeworks
chmod +x ./Scripts/BuildPhases/build-flutter-frameworks.sh
./Scripts/BuildPhases/build-flutter-frameworks.sh || exit 1

# Build KMP framework
chmod +x ./Scripts/BuildPhases/build-kmp-framework.sh
./Scripts/BuildPhases/build-kmp-framework.sh || exit 1

# Build Unity framework
chmod +x ./Scripts/BuildPhases/build-unity-framework.sh
./Scripts/BuildPhases/build-unity-framework.sh || exit 1

# Build Rust library
chmod +x ./Scripts/BuildPhases/build-rust-library.sh
./Scripts/BuildPhases/build-rust-library.sh || exit 1

# Build C library
chmod +x ./Scripts/BuildPhases/build-c-library.sh
./Scripts/BuildPhases/build-c-library.sh || exit 1

# Run SwiftGen
chmod +x ./Scripts/BuildPhases/run-swiftgen.sh
./Scripts/BuildPhases/run-swiftgen.sh || exit 1

# Generate Xcode project and install pods
tuist generate --no-open && pod install && pod update
