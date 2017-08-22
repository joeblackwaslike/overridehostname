PROJECT := overridehostname
IMAGE := $(PROJECT)-builder
USER := joeblackwaslike
# TAG = $(shell git tag | sort -n | tail -1)

.PHONY: all build-builder build run clean shell templates test rm

all: build-builder build

build-builder:
	@docker build -t $(IMAGE) .

build:
	docker run --rm --name $(IMAGE) \
		-v $(PWD)/$(PROJECT):/build/$(PROJECT) $(IMAGE)

run:
	@docker run -d --name $(IMAGE) \
		-e "STAY_UP=true" \
		-v $(PWD)/$(PROJECT):/build/$(PROJECT) \
		$(IMAGE)
	@docker logs -f $(IMAGE)

clean:
	@rm -rf $(PROJECT)/bin/*.so*

shell:
	@docker exec -ti $(IMAGE) bash

templates:
	tmpld --strict --data=templates/vars.yaml \
		$(shell find templates -type f -name '*.j2' | xargs)

test:
	tests/run -v $(PWD):/repo joeblackwaslike/debian:stretch tail -f /dev/null

rm:
	@docker rm -f $(IMAGE)
