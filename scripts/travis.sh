#!/usr/bin/env bash

set -e

xcodebuild -project NetworkKit.xcodeproj -scheme "NetworkKit" -destination "platform=iOS Simulator,name=iPhone 6" test