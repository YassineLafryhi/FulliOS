TARGET=$(basename "$SRCROOT")
PROJECT_FILE_PATH="${SRCROOT}/${TARGET}.xcodeproj"

"$PODS_ROOT/R.swift/rswift" generate --target "$TARGET" --xcodeproj "$PROJECT_FILE_PATH" "$SRCROOT/$TARGET/Sources/Generated/R.generated.swift"
