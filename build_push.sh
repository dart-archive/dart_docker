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
# For dev and beta versions the 'dev' or 'beta' tag will be pushed instead of
# the 'latest' tag.
#
# To test without pushing to the official google namespace change the
# NAMESPACE variable below to some other namespace on hub.docker.com.

set -e

REPO_ROOT=$(dirname "${BASH_SOURCE[0]}")

function usage {
  echo "Usage: $0 <namespace> <channel> <version> [tag_version]

<namespace> is the docker namespace (for production this should
be 'google').

<channel> is the release channel for the dart version (stable, beta, or dev)

<version> is the dart version that should be built into the
docker container.

[tag_version] is optional and will be used instead of the dart version
to tag the images.

This script will build 4 different docker images

  <namespace>/dart
  <namespace>/dart-runtime-base
  <namespace>/dart-runtime
  <namespace>/dart-hello

Each with two tags 'latest' and the actual version.

When the images have been build they are pushed to hub.docker.com. For
dev and beta versions (versions which contain '-dev') the 'dev' or
'beta' tag will be pushed instead of the 'latest' tag."

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

# Check whether the version is a stable version.
function is_stable_version {
  [[ $CHANNEL == 'stable' ]]
}

# Adds the tags to the IMAGE_TAGS array.
#
# By default the image will be tagged as the version specified as well as the
# major.minor. For stable it will also tag as major. For beta or dev it will also
# be tagged as beta or dev respectively.
function get_tags {
  IMAGE_TAGS=(
    $NAMESPACE/$IMAGE:$VERSION
  )

  if is_stable_version;
  then
    IMAGE_TAGS+=(
      $NAMESPACE/$IMAGE:$MAJOR_VERSION
      $NAMESPACE/$IMAGE:$MAJOR_VERSION.$MINOR_VERSION
    )
  else
    IMAGE_TAGS+=(
      $NAMESPACE/$IMAGE:$CHANNEL
      $NAMESPACE/$IMAGE:$MAJOR_VERSION.$MINOR_VERSION-$CHANNEL
    )
  fi
}

# Validate that the Dart VM in the image has the expected version.
function validate_version {
  IMAGE=$1

  VM_VERSION=$(docker run --entrypoint=/usr/bin/dart \
               $NAMESPACE/$IMAGE --version 2>&1)
  if string_contains $DART_VERSION "$VM_VERSION";
  then
    echo "Validated $DART_VERSION in $NAMESPACE/$IMAGE"
  else
    echo "Did not find version $DART_VERSION in $IMAGE (found $VM_VERSION)"
    exit -1
  fi
}

# Build from directory $1 and tag with $2.
function build_and_tag {
  DIRECTORY=$1
  IMAGE=$2
  get_tags $IMAGE

  echo "Building $DIRECTORY with tags $NAMESPACE/$IMAGE" \
       " and $NAMESPACE/$IMAGE:$VERSION"
  # Create Dockerfile from template.
  sed -e s/{{VERSION}}/$DART_VERSION/ \
      -e s/{{NAMESPACE}}/${NAMESPACE//\//\\/}/ \
      $REPO_ROOT/$DIRECTORY/Dockerfile.template > \
      $REPO_ROOT/$DIRECTORY/Dockerfile

  # Build and tag.
  docker build -t $NAMESPACE/$IMAGE $REPO_ROOT/$DIRECTORY

  for i in "${IMAGE_TAGS[@]}"
  do
    docker tag $NAMESPACE/$IMAGE $i
  done

  # Check the Dart version in the image.
  validate_version $IMAGE
  validate_version "$IMAGE:$VERSION"
}

function push_image {
  IMAGE=$1
  get_tags $IMAGE

  # Add the latest tag to the push
  if is_stable_version;
  then
    IMAGE_TAGS+=($NAMESPACE/$IMAGE:latest)
  fi

  for i in "${IMAGE_TAGS[@]}"
  do
    echo "Pushing $i"
    docker push $i
  done
}

# Expect three or four arguments, namespace channel dart_version [tag_version]
if ! ([ $# -eq 3 ] || [ $# -eq 4 ]);
then
  usage
fi

NAMESPACE=$1
CHANNEL=$2
DART_VERSION=$3
VERSION=${4:-$DART_VERSION}

# Read the version string. Patch version is not used
IFS='.' read MAJOR_VERSION MINOR_VERSION PATCH_VERSION <<<"$VERSION"

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
build_and_tag hello dart-hello

echo 'Pushing...'
push_image dart
push_image dart-runtime-base
push_image dart-runtime
push_image dart-hello
echo 'Done!'
