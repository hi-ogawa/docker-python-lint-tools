VCS_REF ?= $(shell git rev-parse --short HEAD)
IMAGE_TAG ?= hiogawa/python-lint-tools:$(VCS_REF)

# Tools
HADOLINT ?= docker run --rm -i hadolint/hadolint:v2.7.0-alpine
PRETTIER ?= docker run --rm -v $(PWD):/work tmknom/prettier:2.0.5

# Auto generate .PHONY
.PHONY: $(shell grep --no-filename -E '^([a-zA-Z_-]|\/)+:' $(MAKEFILE_LIST) | sed 's/:.*//')

all: build

build:
	docker build --no-cache -t $(IMAGE_TAG) - < Dockerfile

build/cache:
	docker build -t $(IMAGE_TAG) - < Dockerfile

lint:
	$(HADOLINT) < Dockerfile
	$(PRETTIER) --check .

lint/fix:
	$(PRETTIER) --write .
