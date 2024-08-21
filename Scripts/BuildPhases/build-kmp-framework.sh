SHARED_FRAMEWORK="$SRCROOT/Frameworks/shared.framework"
KMM_MODULE="$SRCROOT/KotlinMultiplatformModule"

build_kmp_framework() {
    java_version=$(java -version 2>&1 | awk -F'"' '/version/ {print $2}')
    if ! [[ $java_version =~ ^17\..*$ ]]; then
        echo "error: Java version 17 is required to build KMM Framework (found $java_version)."
        return 1
    fi
    cd "$KMM_MODULE"
    ./gradlew clean
    ./gradlew :shared:embedAndSignAppleFrameworkForXcode
    cp -r ./shared/build/bin/iosArm64/debugFramework/shared.framework "$SRCROOT/Frameworks"
}

if [ ! -d "$SHARED_FRAMEWORK" ]; then
    build_kmp_framework
else
    changes=$(git -C "$SRCROOT" status --porcelain "$KMM_MODULE")
    if [ ! -z "$changes" ]; then
        build_kmp_framework
    fi
fi
