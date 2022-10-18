DIST := dist
DIST_TEST := TestProject/Assets/Plugins/NativePlugin

.PHONY: build
build:
	@make -C iOS/UnityPlugin build TARGET=iphoneos
	@rm -rf $(DIST) && mkdir -p $(DIST)/iOS
	@cp -r iOS/UnityPlugin/*.framework{,.meta} $(DIST)/iOS
	@cp -r Editor *.cs $(DIST)

.PHONY: build-sim
build-sim:
	@make -C iOS/UnityPlugin build TARGET=iphonesimulator
	@rm -rf $(DIST_TEST) && mkdir -p $(DIST_TEST)/iOS
	@cp -r iOS/UnityPlugin/*.framework{,.meta} $(DIST_TEST)/iOS
	@cp -r Editor *.cs $(DIST_TEST)

.PHONY: push
push: build
	@git subtree push --prefix dist origin dist
