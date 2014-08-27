#! /bin/bash
# Build the Docker images for Dart.
VERSION=1.5.8
docker build -t google/dart base
docker tag google/dart google/dart:$VERSION
docker build -t google/dart-runtime runtime
docker tag google/dart google/dart-runtime:$VERSION
cd hello
pub update
cd ..
docker build -t google/dart-hello hello
docker tag google/dart-hello google/dart-hello:$VERSION
