MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := build

DOMAIN = quay.io
NS = blackstar257
INSTANCE = default

REPO ?= $(shell basename `git rev-parse --show-toplevel`)
VERSION ?= $(shell basename `git rev-parse HEAD`)
BRANCH ?= $(shell basename `git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`)
export REPO := ${REPO}
export VERSION := ${VERSION}
export NAME := ${REPO}
export BRANCH := ${BRANCH}

.PHONY: build tag push compose shell run start stop rm release

build:
	docker build -t $(DOMAIN)/$(NS)/$(REPO):$(VERSION) .

tag:
	docker tag $(DOMAIN)/$(NS)/$(REPO):$(VERSION) $(DOMAIN)/$(NS)/$(REPO):$(BRANCH)

push:
	docker push $(DOMAIN)/$(NS)/$(REPO):$(VERSION)
	docker push $(DOMAIN)/$(NS)/$(REPO):$(BRANCH)

shell:
	docker run --rm --name $(NAME)-$(INSTANCE) -i -t $(PORTS) $(VOLUMES) $(ENV) $(DOMAIN)/$(NS)/$(REPO):$(VERSION) /bin/bash

run:
	docker run --rm --name $(NAME)-$(INSTANCE) -p 2222:22 $(VOLUMES) $(ENV) $(DOMAIN)/$(NS)/$(REPO):$(VERSION)

start:
	docker run -d --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(DOMAIN)/$(NS)/$(REPO):$(VERSION)

stop:
	docker stop $(NAME)-$(INSTANCE)

rm:
	docker rm $(NAME)-$(INSTANCE)

release: build
	make push -e VERSION=$(VERSION)

default: build
