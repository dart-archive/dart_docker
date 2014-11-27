dart_docker
===========

This repository contains the sources for the following
[docker](https://docker.io) base images:

- [`google/dart`](/base)
- [`google/dart-appengine`](/appengine)
- [`google/dart-runtime`](/runtime)
- [`google/dart-hello`](/hello)

Currently these images are build automatically on the official Docker
registry https://registry.hub.docker.com/repos/google/ using the
"Automated build" feature.

For testing the images the script `build.sh` can be used. It will build the
images locally in the `google_test` namespace. Note when using this script the
`Dockerfile`s need to be changed to be based on the `google_test` namespace.

For testing with a custom build of Dart where an already built Dart .deb file
is used the script `build_custom.sh` can be used.
