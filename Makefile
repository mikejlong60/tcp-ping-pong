VERSION?=1.0


help: ## list available commands
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-30s\033[0m %s\n", $$1, $$2}'

docker-build-server: ## build docker image with VERSION tag
	$(eval COMMIT=$(shell git rev-parse --short HEAD))
	$(eval ISDIRTY=$(shell git diff-index --quiet HEAD -- || echo '-dirty'))
	$(eval IMAGE_NAME=ping-server)
	$(eval VERSION=1.0)
	docker build \
	--build-arg COMMIT="${COMMIT}" \
	--build-arg TAG="${VERSION}" \
	--build-arg ISDIRTY="${ISDIRTY}" \
	--no-cache --rm --tag $(IMAGE_NAME):$(VERSION) \
	 -f Dockerfile-server .

docker-build-client: ## build docker image with VERSION tag
	$(eval VERSION=1.0)
	$(eval COMMIT=$(shell git rev-parse --short HEAD))
	$(eval ISDIRTY=$(shell git diff-index --quiet HEAD -- || echo '-dirty'))
	$(eval IMAGE_NAME=ping-client)
	docker build \
	--build-arg TAG="${VERSION}" \
	--build-arg COMMIT="${COMMIT}" \
	--build-arg ISDIRTY="${ISDIRTY}" \
	--no-cache --rm --tag $(IMAGE_NAME):$(VERSION) \
	 -f Dockerfile-client .

