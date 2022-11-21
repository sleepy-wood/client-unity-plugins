DIST := dist
DIST_TEST := TestProject/Assets/Plugins/NativePlugin

.PHONY: build
build:
	@make -C iOS/UnityPlugin build TARGET=iphoneos
	@rm -rf $(DIST) && mkdir -p $(DIST)/iOS
	@cp -r iOS/UnityPlugin/*.framework{,.meta} $(DIST)/iOS
	@cp -r Editor Runtime Resources $(DIST)

.PHONY: build-sim
build-sim:
	@make -C iOS/UnityPlugin build TARGET=iphoneos
	@rm -rf $(DIST_TEST) && mkdir -p $(DIST_TEST)/iOS
	@cp -r iOS/UnityPlugin/*.framework{,.meta} $(DIST_TEST)/iOS
	@cp -r Editor Runtime Resources $(DIST_TEST)

.PHONY: push
push: build
#	@git subtree push --prefix dist origin dist
	@echo "gitdir: $(shell pwd)/.git/worktrees/dist" > dist/.git
	@git -C dist add .
	@git -C dist commit -m 'feat: update'
	@git -C dist push origin dist

.PHONY: format
format:
	@swiftformat .
	@dotnet csharpier .
