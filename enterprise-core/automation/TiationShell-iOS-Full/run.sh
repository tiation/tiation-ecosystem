#!/bin/bash
# Launch TiationShell in simulator

DEVICE="iPhone 16 Pro"
echo "🚀 Launching TiationShell on $DEVICE simulator..."

# Build and run
xcodebuild -scheme TiationShell \
    -destination "platform=iOS Simulator,name=$DEVICE" \
    -derivedDataPath build \
    clean build

# Install and launch
SIMULATOR_ID=$(xcrun simctl list devices | grep "$DEVICE" | grep -E -o "[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}" | head -1)

if [ -z "$SIMULATOR_ID" ]; then
    echo "❌ Could not find $DEVICE simulator"
    exit 1
fi

# Boot simulator if needed
xcrun simctl boot "$SIMULATOR_ID" 2>/dev/null || true

# Install app
APP_PATH=$(find build/Build/Products -name "TiationShell.app" | head -1)
if [ -n "$APP_PATH" ]; then
    xcrun simctl install "$SIMULATOR_ID" "$APP_PATH"
    xcrun simctl launch "$SIMULATOR_ID" com.tiation.TiationShell
    echo "✅ App launched successfully"
else
    echo "❌ Could not find built app"
    exit 1
fi
