# If DRYCC_REGISTRY is not set, try to populate it from legacy DEV_REGISTRY
DRYCC_REGISTRY ?= $(DEV_REGISTRY)
IMAGE_PREFIX ?= drycc-addons
COMPONENT ?= adminer
SHORT_NAME ?= $(COMPONENT)
PLATFORM ?= linux/amd64,linux/arm64
ADMINER_VERSION ?= 4.8.1

include versioning.mk

DEV_ENV_IMAGE := ${DRYCC_REGISTRY}/drycc/go-dev
DEV_ENV_WORK_DIR := /opt/drycc/go/src/${REPO_PATH}
DEV_ENV_CMD := podman run --rm -v ${CURDIR}:${DEV_ENV_WORK_DIR} -w ${DEV_ENV_WORK_DIR} ${DEV_ENV_IMAGE}

# Test processes used in quick unit testing
TEST_PROCS ?= 4

check-podman:
	@if [ -z $$(which podman) ]; then \
	  echo "Missing \`podman\` client which is required for development"; \
	  exit 2; \
	fi

build: podman-build

podman-build: check-podman
	podman build ${PODMAN_BUILD_FLAGS} -t ${IMAGE} ${ADMINER_VERSION}/debian
	podman tag ${IMAGE} ${MUTABLE_IMAGE}

clean: check-podman
	podman rmi $(IMAGE)

full-clean: check-podman
	podman images -q $(IMAGE_PREFIX)/$(COMPONENT) | xargs podman rmi -f

.PHONY: build podman-build clean commit-hook full-clean
