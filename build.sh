#! /bin/bash
# Build the Docker images for Dart.
#
# This is only used to test the Docker images locally. For distribution
# the automated builds on hub.docker.com is used.

# Pull the latest version of the base image from a Dockerfile.
function pull_base_image {
  BASE_IMAGE=$(awk '/^FROM[ \t\r\n\v\f]/ { print /:/ ? $2 : $2":latest" }' $1)
  docker pull $BASE_IMAGE
}

VERSION=1.7.2
REPOSITORY_PREFIX=google_test
echo 'Building base'
# TODO: Change this to use the --pull option to docker build when that is
# released.
pull_base_image base/Dockerfile
docker build -t $REPOSITORY_PREFIX/dart base
docker tag $REPOSITORY_PREFIX/dart $REPOSITORY_PREFIX/dart:$VERSION
echo 'Building runtime-base'
docker build -t $REPOSITORY_PREFIX/dart-runtime-base runtime-base
docker tag $REPOSITORY_PREFIX/dart-runtime-base \
    $REPOSITORY_PREFIX/dart-runtime-base:$VERSION
echo 'Building runtime'
docker build -t $REPOSITORY_PREFIX/dart-runtime runtime
docker tag $REPOSITORY_PREFIX/dart-runtime $REPOSITORY_PREFIX/dart-runtime:$VERSION
echo 'Building hello'
cd hello
pub update
cd ..
docker build -t $REPOSITORY_PREFIX/dart-hello hello
docker tag $REPOSITORY_PREFIX/dart-hello $REPOSITORY_PREFIX/dart-hello:$VERSION
