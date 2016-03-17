#!/usr/bin/env bash

set -e

xcodebuild -workspace NetworkKit.xcodeproj -scheme "NetworkKit" -destination "platform=iOS Simulator,name=iPhone 6" test
xcodebuild -workspace NetworkKit.xcodeproj -scheme "NetworkKitMac" test
xcodebuild -workspace NetworkKit.xcodeproj -scheme "NetworkKitTvOS" -destination "platform=tvOS Simulator,name=Apple TV 1080p" test