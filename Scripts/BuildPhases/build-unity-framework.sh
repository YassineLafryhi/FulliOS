#!/bin/sh

#UNITY_PATH="/Applications/Unity/Hub/Editor/2022.3.37f1/Unity.app/Contents/MacOS/Unity"
UNITY_BASE_PATH="/Applications/Unity/Hub/Editor"
HIGHEST_VERSION=$(ls "$UNITY_BASE_PATH" | sort -Vr | head -n 1)
UNITY_PATH="$UNITY_BASE_PATH/$HIGHEST_VERSION/Unity.app/Contents/MacOS/Unity"

UNITY_FRAMEWORK="$SRCROOT/Frameworks/UnityFramework.framework"
UNITY_PROJECT_PATH="$SRCROOT/UnityGame"

build_unity_framework() {
if [[ "$PLATFORM_NAME" == *"simulator"* ]]; then
    echo "Building for iOS Simulator"
    SIMULATOR_FLAG="-simulator"
else
    echo "Building for iOS Device"
    SIMULATOR_FLAG=""
fi

echo "warning: $PLATFORM_NAME"

"$UNITY_PATH" -batchmode -nographics -silent-crashes -logFile "$UNITY_PROJECT_PATH/unity.log" \
    -projectPath "$UNITY_PROJECT_PATH" \
    -executeMethod BuildScript.PerformiOSBuild \
    -buildTarget iOS \
    $SIMULATOR_FLAG \
    -quit

xcodebuild -project "$UNITY_PROJECT_PATH/Builds/iOS/Unity-iPhone.xcodeproj" -scheme UnityFramework -sdk iphoneos -configuration Release -derivedDataPath "$UNITY_PROJECT_PATH/Builds"
cp -r "$UNITY_PROJECT_PATH/Builds/Build/Products/Release-iphoneos/UnityFramework.framework" "$UNITY_FRAMEWORK"

if [ $? -eq 0 ]; then
    echo "warning: Unity iOS build completed successfully."
else
    echo "error: Unity iOS build failed. Check the log file for details."
    exit 1
fi
}

if [ ! -d "$UNITY_FRAMEWORK" ]; then
    build_unity_framework
else
    changes=$(git -C "$SRCROOT" status --porcelain "$UNITY_PROJECT_PATH")
    if [ ! -z "$changes" ]; then
        build_unity_framework
    fi
fi
