TARGET := iphoneos

.PHONY: build
build:
	@rm -rf *.framework
	@swift package generate-xcodeproj --skip-extra-files
	@xcodebuild ENABLE_BITCODE=Yes BITCODE_GENERATION_MODE=bitcode OTHER_CFLAGS="-fembed-bitcode" -project UnityPlugin.xcodeproj -scheme UnityPlugin-Package -configuration Release -sdk $(TARGET) CONFIGURATION_BUILD_DIR=.
