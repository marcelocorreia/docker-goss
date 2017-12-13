REPOSITORY=docker-goss
CONTAINER=goss
NAMESPACE=marcelocorreia
VERSION=$(shell cat version)
PIPELINE_NAME=$(REPOSITORY)-release
CI_TARGET=dev

build:
	docker build -t $(NAMESPACE)/$(CONTAINER):latest .
.PHONY: build

show-name:
	echo $(NAMESPACE)/$(CONTAINER):latest

build_dev:
	docker build -t $(CONTAINER):dev .
.PHONY: build

docker-shell:
	docker run --rm -it -v ~/Downloads/:/opt/workspace $(CONTAINER):dev bash

#update-version:
#	cat Dockerfile | sed  's/ARG version=".*"/ARG version="$(VERSION)"/' > /tmp/Dockerfile.tmp
#	cat /tmp/Dockerfile.tmp > Dockerfile
#	rm /tmp/Dockerfile.tmp


git-push:
	git add .; git commit -m "Pipeline WIP"; git push

set-pipeline: git-push
	fly -t $(CI_TARGET) set-pipeline \
		-n -p $(PIPELINE_NAME) \
		-c pipeline.yml \
		-l $(HOME)/.ssh/ci-credentials.yml \
		-v git_repo_url=git@github.com:marcelocorreia/$(REPOSITORY).git \
        -v container_fullname=$(NAMESPACE)/$(CONTAINER) \
        -v container_name=$(CONTAINER) \
		-v git_repo=$(REPOSITORY) \
        -v git_branch=master \
        -v release_version=$(VERSION)

	fly -t $(CI_TARGET) unpause-pipeline -p $(PIPELINE_NAME)
.PHONY: set-pipeline

trigger-job:
	fly -t $(CI_TARGET) trigger-job -j $(PIPELINE_NAME)/$(PIPELINE_NAME)

pipeline-login:
	fly -t dev login -n dev -c https://ci.correia.io

watch-pipeline:
	fly -t $(CI_TARGET) watch -j $(PIPELINE_NAME)/$(PIPELINE_NAME)
.PHONY: watch-pipeline

destroy-pipeline:
	fly -t $(CI_TARGET) destroy-pipeline -p $(PIPELINE_NAME)
.PHONY: destroy-pipeline

docs:
	grip -b




