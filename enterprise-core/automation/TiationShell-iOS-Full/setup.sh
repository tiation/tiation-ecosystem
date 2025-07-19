#!/bin/bash

# TiationShell iOS Setup Script
# This script sets up the full TiationShell iOS project

echo "🚀 TiationShell iOS Full Setup"
echo "=============================="

# Check for Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode is required but not installed"
    echo "Please install Xcode from the App Store"
    exit 1
fi

echo "✅ Xcode found"

# Create project structure
echo "📁 Creating project structure..."
mkdir -p Sources/TiationShell/{Views,Extensions,Core}
mkdir -p Tests/TiationShellTests
mkdir -p TiationShellFileProvider

# Copy existing views to the Views folder
if [ -f "../TiationShell-iOS/TiationShell/ContentView.swift" ]; then
    cp ../TiationShell-iOS/TiationShell/ContentView.swift Sources/TiationShell/Views/
    echo "✅ Copied ContentView.swift"
fi

# Create .gitignore
cat > .gitignore << EOF
# Xcode
.DS_Store
build/
DerivedData/
*.xcodeproj/xcuserdata/
*.xcworkspace/xcuserdata/

# Swift Package Manager
.build/
.swiftpm/

# CocoaPods
Pods/

# Carthage
Carthage/Build/

# fastlane
fastlane/report.xml
fastlane/Preview.html
fastlane/screenshots/**/*.png
fastlane/test_output

# Code Injection
iOSInjectionProject/
EOF

echo "✅ Created .gitignore"

# Create Xcode project
echo "🔨 Creating Xcode project..."
swift package generate-xcodeproj

# Create File Provider Info.plist
cat > TiationShellFileProvider/Info.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSExtension</key>
    <dict>
        <key>NSExtensionFileProviderDocumentGroup</key>
        <string>group.com.tiation.tiationshell</string>
        <key>NSExtensionPointIdentifier</key>
        <string>com.apple.fileprovider-nonui</string>
        <key>NSExtensionPrincipalClass</key>
        <string>$(PRODUCT_MODULE_NAME).FileProviderExtension</string>
    </dict>
</dict>
</plist>
EOF

echo "✅ Created File Provider configuration"

# Install dependencies
echo "📦 Resolving Swift Package dependencies..."
swift package resolve

# Create example SSH key for testing
mkdir -p ~/Documents/TiationShell/ssh_keys
if [ ! -f ~/Documents/TiationShell/ssh_keys/test_key ]; then
    ssh-keygen -t rsa -b 2048 -f ~/Documents/TiationShell/ssh_keys/test_key -N ""
    echo "✅ Created test SSH key"
fi

# Create launch script
cat > run.sh << 'EOF'
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
EOF

chmod +x run.sh

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Open Package.swift in Xcode"
echo "2. Add File Provider extension target"
echo "3. Configure capabilities (App Groups, Keychain Sharing)"
echo "4. Build and run the project"
echo ""
echo "Or use the command line:"
echo "  ./run.sh    # Build and run in simulator"
echo ""
echo "For production deployment:"
echo "1. Configure code signing"
echo "2. Add to App Store Connect"
echo "3. Submit for review"
echo ""
echo "Happy coding! 🎉"
