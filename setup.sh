SRCROOT=$(pwd)
PODS_ROOT=$SRCROOT/Pods
export SRCROOT
export PODS_ROOT

if [ -d "$SRCROOT/FulliOS/Sources/Generated" ]; then
  rm -rf $SRCROOT/FulliOS/Sources/Generated
fi
mkdir -p $SRCROOT/FulliOS/Sources/Generated

# Run SwiftGen
chmod +x ./Scripts/BuildPhases/run-swiftgen.sh
./Scripts/BuildPhases/run-swiftgen.sh || exit 1

# Run R.swift
chmod +x ./Scripts/BuildPhases/run-rswift.sh
./Scripts/BuildPhases/run-rswift.sh || exit 1

# Generate Xcode project and install pods
tuist generate --no-open && pod install && pod update
