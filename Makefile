.PHONY: build
build:
	@make -C iOS/UnityPlugin build

.PHONY: push
push: build
	@git subtree push --prefix dist origin binary
