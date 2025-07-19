#!/bin/bash

# Quick iOS App Runner for RiggerConnect
# This script sets up and runs the iOS app with your dark neon theme

set -e

# Colors for dark neon theme output
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${CYAN}🚀 RiggerConnect iOS Quick Launch${NC}"
echo -e "${MAGENTA}===================================${NC}"

# Navigate to the app directory
cd /Users/tiaastor/tiation-github/tiation-rigger-workspace/RiggerConnectMobileApp

echo -e "${CYAN}📱 Starting iOS Simulator and launching app...${NC}"

# Method 1: Try launching iOS Simulator directly
echo -e "${GREEN}✨ Opening iOS Simulator...${NC}"
open -a Simulator

# Wait a moment for simulator to start
sleep 3

# Method 2: Build and run using Xcode command line
echo -e "${GREEN}🔨 Building and running app...${NC}"
xcodebuild \
  -workspace ios/RiggerConnectMobileApp.xcworkspace \
  -scheme RiggerConnectMobileApp \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro,OS=latest' \
  -derivedDataPath ios/build \
  build

# Install and run the app on simulator
echo -e "${GREEN}📲 Installing app on simulator...${NC}"
xcrun simctl install booted ios/build/Build/Products/Debug-iphonesimulator/RiggerConnectMobileApp.app

echo -e "${GREEN}🎉 Launching RiggerConnect app...${NC}"
xcrun simctl launch booted com.tiation.riggerconnectmobileapp

echo -e "${CYAN}✅ RiggerConnect iOS app is now running!${NC}"
echo -e "${MAGENTA}Features:${NC}"
echo -e "${GREEN}  🏗️  Job Management with dark neon theme${NC}"
echo -e "${GREEN}  👨‍💼  Worker Portal with cyan/magenta gradients${NC}"
echo -e "${GREEN}  📊  Analytics Dashboard${NC}"
echo -e "${GREEN}  🔒  Enterprise Security${NC}"
echo ""
echo -e "${CYAN}Your enterprise-grade mining & construction app is ready!${NC}"
