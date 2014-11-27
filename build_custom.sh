#!/bin/bash
# Build a Docker image with Dart using a specific .deb file.
#
# This is only used for testing with a custom build of Dart where
# an already built Dart .deb file is used.
#
# To build a .deb file for Dart please use the tools from the
# Dart repository
#
#   tools/create_tarball.py
#   tools/create_debian_packages.py
#
# Depending on the Linux version used as the base image, you
# might also need to compile inside a chroot environment, depending
# on the Linux version of where the .deb file is build. The
# Dart repository also have a script for setting up a chroot
# environment for building Dart.
#
#  tools/create_debian_chroot.sh

REPO_ROOT=$(dirname "${BASH_SOURCE[0]}")
REPOSITORY_PREFIX=google_test

function usage {
  echo "Usage: $0 <path to .deb file>"
  exit 1
}

if [ $# -lt 1 ] || [ $# -gt 1 ]
then
  usage
fi

echo 'Building base-custom'
cp $1 $REPO_ROOT/base-custom/dart.deb
docker build -t $REPOSITORY_PREFIX/dart $REPO_ROOT/base-custom
docker tag $REPOSITORY_PREFIX/dart $REPOSITORY_PREFIX/dart-custom
rm $REPO_ROOT/base-custom/dart.deb
