DIST := dist

.PHONY: build
build:
	@make -C iOS/UnityPlugin build
	@rm -rf $(DIST) && mkdir -p $(DIST)/iOS
	@cp -r iOS/UnityPlugin/UnityPlugin.framework dist/iOS
	@cp NativePlugin.cs $(DIST)

.PHONY: push
push: build
	@git subtree push --prefix dist origin dist

