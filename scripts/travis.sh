#!/usr/bin/env bash

set -e

xcodebuild -project NetworkKit.xcodeproj -scheme NetworkKit -sdk iphonesimulator8.0 -configuration Debug clean build
xcodebuild -project NetworkKit.xcodeproj -scheme NetworkKit -destination "platform=iOS Simulator,name=iPhone 6" test