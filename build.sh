#!/bin/bash
# Build the Docker images for Dart.
#
# This is only used to test the Docker images locally. For distribution
# the automated builds on hub.docker.com is used.

# Pull the latest version of the base image from a Dockerfile.
function pull_base_image {
  BASE_IMAGE=$(awk '/^FROM[ \t\r\n\v\f]/ { print /:/ ? $2 : $2":latest" }' $1)
  docker pull $BASE_IMAGE
}

VERSION=1.8.3
REPOSITORY_PREFIX=google
REPO_ROOT=$(dirname "${BASH_SOURCE[0]}")

echo 'Building base'
# TODO: Change this to use the --pull option to docker build when that is
# released.
pull_base_image $REPO_ROOT/base/Dockerfile
docker build -t $REPOSITORY_PREFIX/dart $REPO_ROOT/base
docker tag $REPOSITORY_PREFIX/dart $REPOSITORY_PREFIX/dart:$VERSION
echo 'Building runtime-base'
docker build -t $REPOSITORY_PREFIX/dart-runtime-base $REPO_ROOT/runtime-base
docker tag $REPOSITORY_PREFIX/dart-runtime-base \
    $REPOSITORY_PREFIX/dart-runtime-base:$VERSION
echo 'Building runtime'
docker build -t $REPOSITORY_PREFIX/dart-runtime $REPO_ROOT/runtime
docker tag $REPOSITORY_PREFIX/dart-runtime $REPOSITORY_PREFIX/dart-runtime:$VERSION
echo 'Building hello'
pushd $REPO_ROOT/hello
pub update
popd
docker build -t $REPOSITORY_PREFIX/dart-hello $REPO_ROOT/hello
docker tag $REPOSITORY_PREFIX/dart-hello $REPOSITORY_PREFIX/dart-hello:$VERSION
