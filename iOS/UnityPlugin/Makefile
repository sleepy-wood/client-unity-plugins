TARGET := iphoneos

.PHONY: build
build:
	@rm -rf *.framework
	@swift package generate-xcodeproj --skip-extra-files
	@xcodebuild -project UnityPlugin.xcodeproj -scheme UnityPlugin-Package -configuration Release -sdk $(TARGET) CONFIGURATION_BUILD_DIR=.
