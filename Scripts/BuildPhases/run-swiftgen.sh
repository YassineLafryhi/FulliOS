TARGET=$(basename "$SRCROOT")
if [ ! -d "$SRCROOT/$TARGET/Sources/Generated" ]; then
  mkdir -p "$SRCROOT/$TARGET/Sources/Generated"
fi

SWIFTGEN_CONFIG_FILE="${SRCROOT}/swiftgen.yml"
SWIFTGEN_BIN="${PODS_ROOT}/SwiftGen/bin/swiftgen"
"$SWIFTGEN_BIN" config run --config "$SWIFTGEN_CONFIG_FILE"
