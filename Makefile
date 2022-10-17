.PHONY: build
build:
	@make -C iOS/UnityPlugin build TARGET=iphoneos
	@rm -rf dist && mkdir -p dist/iOS
	@cp -r iOS/UnityPlugin/*.framework dist/iOS
	@cp *.cs dist

.PHONY: build-sim
build-sim:
	@make -C iOS/UnityPlugin build TARGET=iphonesimulator
	@rm -rf dist-sim && mkdir -p dist-sim/iOS
	@cp -r iOS/UnityPlugin/*.framework dist/iOS
	@cp *.cs dist-sim

.PHONY: push
push: build
	@git subtree push --prefix dist origin dist
