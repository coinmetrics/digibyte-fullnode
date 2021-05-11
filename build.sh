#!/bin/sh

set -e

export DOCKER_REGISTRY_REPO="${DOCKER_REGISTRY_REPO:-"$(basename "$PWD")"}"

export VERSION=$(cat version.txt)
export VERSION_SHORT=$(cat version_short.txt)
echo "Building $DOCKER_REGISTRY_REPO version ${VERSION}."
#echo "Image version ${VERSION} (short ${VERSION_SHORT})."

echo "Building image..."
docker build --build-arg "VERSION=${VERSION}" --build-arg "VERSION_SHORT=${VERSION_SHORT}" -t "${DOCKER_REGISTRY_REPO}:${VERSION}" .
echo "Image ready."

if [ -n "${DOCKER_REGISTRY}" ] && [ -n "${DOCKER_REGISTRY_USER}" ] && [ -n "${DOCKER_REGISTRY_PASSWORD}" ]
then
	echo "Logging into ${DOCKER_REGISTRY}..."
	docker login -u="${DOCKER_REGISTRY_USER}" -p="${DOCKER_REGISTRY_PASSWORD}" "${DOCKER_REGISTRY}"
	echo "Pushing image to ${DOCKER_REGISTRY_REPO}:${VERSION}..."
	docker push "${DOCKER_REGISTRY_REPO}:${VERSION}"
fi
