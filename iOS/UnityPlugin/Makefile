.PHONY: build
build:
	@swift package generate-xcodeproj --skip-extra-files
	@xcodebuild -project UnityPlugin.xcodeproj -scheme UnityPlugin-Package -configuration Release -sdk iphoneos CONFIGURATION_BUILD_DIR=.
