TARGET=$(basename "$SRCROOT")
"$PODS_ROOT/R.swift/rswift" generate "$SRCROOT/$TARGET/Sources/Generated/R.generated.swift"
