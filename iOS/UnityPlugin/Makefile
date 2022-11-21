TARGET := iphoneos

.PHONY: build
build:
	@rm -rf *.framework
	@xcrun coremlcompiler compile  Resources/SleepDetector.mlmodel Sources/UnityPlugin
	@xcrun coremlcompiler generate Resources/SleepDetector.mlmodel Sources/UnityPlugin --language Swift
	@swift package generate-xcodeproj --skip-extra-files
	@xcodebuild ENABLE_BITCODE=Yes BITCODE_GENERATION_MODE=bitcode OTHER_CFLAGS="-fembed-bitcode" -project UnityPlugin.xcodeproj -scheme UnityPlugin-Package -configuration Debug -sdk $(TARGET) CONFIGURATION_BUILD_DIR=.
	@cp -r Sources/UnityPlugin/SleepDetector.mlmodelc UnityPlugin.framework
