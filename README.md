dart_docker
===========

This repository contains the sources for the following
[docker](https://docker.io) base images:

- [`google/dart`](/base)
- [`google/dart-appengine`](/appengine)
- [`google/dart-runtime`](/runtime)
- [`google/dart-hello`](/hello)

## Preparing deployment

Currently these images are build automatically on the official Docker
registry https://registry.hub.docker.com/repos/google/ using the
"Automated build" feature.

However there is currently a manual procedure in preparing this.

1. Update the version in `build.sh` and `base/Dockerfile`

2. Test the change locally using 'build.sh' (See "Local Testing" below)
   and check the result using

    $ docker run google_test/dart /usr/bin/dart --version

3. Commit and automatic building on hub.docker.com (https://registry.hub.docker.com/u/google/dart/) should start

4. Pull the new google/dart image and check the version

    $ docker pull google/dart:latest
    $ docker run google/dart /usr/bin/dart --version

5. On hub.docker.com rebuild all dependent images in this order:

  * google/dart-runtime-base
  * google/dart-runtime
  * google/dart-hello

6. Pull the new google/dart-hello image and check the version

    $ docker pull google/dart-hello:latest
    $ docker run -d -p 8080:8080 google/dart-hello
    $ curl http://$(boot2docker ip):8080/version

## Local testing

For testing the images the script `build.sh` can be used. It will build the
images locally in the `google_test` namespace. Note when using this script the
`Dockerfile`s need to be changed to be based on the `google_test` namespace.

For testing with a custom build of Dart where an already built Dart .deb file
is used the script `build_custom.sh` can be used.
