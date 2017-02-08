PROJECT = overridehostname
IMAGE = $(PROJECT)-builder
USER = joeblackwaslike
# TAG = $(shell git tag | sort -n | tail -1)

.PHONY: build-builder build run clean shell rm

build-builder:
	@docker build -t $(IMAGE) .

build:
	@docker run --rm --name $(IMAGE) \
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

rm:
	@docker rm -f $(IMAGE)

# bump-tag:
# 	@git tag -a $(shell echo $(TAG) | awk -F. '1{$$NF+=1; OFS="."; print $$0}') -m "New Release"
#
# release:
# 	@-git push origin $(TAG)
# 	@github-release release --user $(USER) --repo $(PROJECT) --tag $(TAG)
#
# upload-release:
# 	github-release upload --user $(USER) --repo $(PROJECT) --tag $(TAG) \
# 		--name lib$(PROJECT).so.1 --file $(PROJECT)/bin/lib$(PROJECT).so.1
