#!/bin/bash
# Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.
#
# Build and push the Docker images for Dart.
#
# This script will build and push the Dart docker images.
#
# To push a new version update the VERSION variable below and the
# script will build and push images based on that version of Dart
# installed from the Debian repository.
#
# For developer versions (versions which contain '-dev' the
# 'latest' tag will not be pushed.
#
# To test without pushing to the official google namespace change the
# NAMESPACE variable below to some other namespace on hub.docker.com.

set -e

REPO_ROOT=$(dirname "${BASH_SOURCE[0]}")

function usage {
  echo "Usage: $0 <namespace> <version>

<namespace> is the docker namespace (for production this should
be 'google').

<version> is the dart version that should be built into the
docker container.

This script will build 4 different docker images

  <namespace>/dart
  <namespace>/dart-runtime-base
  <namespace>/dart-runtime
  <namespace>/dart-hello

Each with two tags 'latest' and the actual version.

When the images have been build they are pushed to hub.docker.com. For
developer versions (versions which contain '-dev' the 'latest' tag will not
be pushed."

  exit 1
}

# Find the name of the base image in the Dockerfile in $1.
function base_image {
  awk '/^FROM[ \t\r\n\v\f]/ { print /:/ ? $2 : $2":latest" }' $1
}

# Check whether $1 is contained in $2.
function string_contains {
  [[ $2 == *$1* ]]
}

# Check whether $1 is not contained in $2.
function string_not_contains {
  [[ $2 != *$1* ]]
}

# Check whether the version is a developer version.
function is_not_dev_version {
  string_not_contains '-dev' $VERSION
}

# Validate that the Dart VM in the image has the expected version.
function validate_version {
  IMAGE=$1

  VM_VERSION=$(docker run --entrypoint=/usr/bin/dart \
               $NAMESPACE/$IMAGE --version 2>&1)
  if string_contains $VERSION "$VM_VERSION";
  then
    echo "Validated $VERSION in $NAMESPACE/$IMAGE"
  else
    echo "Did not find version $VERSION in $IMAGE (found $VM_VERSION)"
    exit -1
  fi
}

# Build from directory $1 and tag with $2.
function build_and_tag {
  DIRECTORY=$1
  IMAGE=$2

  echo "Building $DIRECTORY with tags $NAMESPACE/$IMAGE" \
       " and $NAMESPACE/$IMAGE:$VERSION"
  # Create Dockerfile from template.
  sed -e s/{{VERSION}}/$VERSION/ \
      -e s/{{NAMESPACE}}/$NAMESPACE/ \
      $REPO_ROOT/$DIRECTORY/Dockerfile.template > \
      $REPO_ROOT/$DIRECTORY/Dockerfile

  # Build and tag.
  docker build -t $NAMESPACE/$IMAGE $REPO_ROOT/$DIRECTORY
  docker tag $NAMESPACE/$IMAGE $NAMESPACE/$IMAGE:$VERSION

  # Check the Dart version in the image.
  validate_version $IMAGE
  validate_version "$IMAGE:$VERSION"
}

function push_image {
  IMAGE=$1

  if is_not_dev_version;
  then
    echo "Pushing $NAMESPACE/$IMAGE:latest"
    docker push $NAMESPACE/$IMAGE:latest
  fi
  echo "Pushing $NAMESPACE/$IMAGE:$VERSION"
  docker push $NAMESPACE/$IMAGE:$VERSION
}

# Expect two arguments, namespace and version
if [ $# -ne 2 ];
then
  usage
fi

NAMESPACE=$1
VERSION=$2

# Make sure the latest version of the base image is present.
BASE_IMAGE=$(base_image $REPO_ROOT/base/Dockerfile.template)
echo 'Pulling latest version of base image '$BASE_IMAGE
# TODO: Change this to use the --pull option to docker build when that is
# released.
docker pull $BASE_IMAGE
echo 'Building...'
build_and_tag base dart
build_and_tag runtime-base dart-runtime-base
build_and_tag runtime dart-runtime

# Before building hello run 'pub upgrade'.
pushd $REPO_ROOT/hello
pub update
popd
build_and_tag hello dart-hello

echo 'Pushing...'
push_image dart
push_image dart-runtime-base
push_image dart-runtime
push_image dart-hello
echo 'Done!'
