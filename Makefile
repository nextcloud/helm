# CONTAINER_RUNTIME
CONTAINER_RUNTIME?=$(shell which podman)

# NODE_IMAGE
NODE_IMAGE_REGISTRY_HOST?=docker.io
NODE_IMAGE_REPOSITORY?=library/node
NODE_IMAGE_VERSION?=24.10.0-alpine # renovate: datasource=docker registryUrl=https://docker.io depName=docker.io/library/node packageName=library/node
NODE_IMAGE_FULLY_QUALIFIED=${NODE_IMAGE_REGISTRY_HOST}/${NODE_IMAGE_REPOSITORY}:${NODE_IMAGE_VERSION}

# MISSING DOT
# ==============================================================================
missing-dot:
	grep --perl-regexp '## @(param|skip).*[^.]$$' values.yaml

# README
# ==============================================================================
readme: readme/link readme/lint readme/parameters

readme/link:
	npm install && npm run readme:link

readme/lint:
	npm install && npm run readme:lint

readme/parameters:
	npm install && npm run readme:parameters

# CONTAINER RUN - README
# ==============================================================================
PHONY+=container-run/readme
container-run/readme: container-run/readme/link container-run/readme/lint container-run/readme/parameters

container-run/readme/link:
	${CONTAINER_RUNTIME} run \
		--rm \
		--volume $(shell pwd):$(shell pwd) \
		--workdir $(shell pwd) \
			${NODE_IMAGE_FULLY_QUALIFIED} \
				npm install && npm run readme:link

container-run/readme/lint:
	${CONTAINER_RUNTIME} run \
		--rm \
		--volume $(shell pwd):$(shell pwd) \
		--workdir $(shell pwd) \
			${NODE_IMAGE_FULLY_QUALIFIED} \
				npm install && npm run readme:lint

container-run/readme/parameters:
	${CONTAINER_RUNTIME} run \
		--rm \
		--volume $(shell pwd):$(shell pwd) \
		--workdir $(shell pwd) \
			${NODE_IMAGE_FULLY_QUALIFIED} \
				npm install && npm run readme:parameters

# PHONY
# ==============================================================================
# Declare the contents of the PHONY variable as phony. We keep that information
# in a variable so we can use it in if_changed.
.PHONY: ${PHONY}
