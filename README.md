dart_docker
===========

This repository contains the sources for the following
[docker](https://docker.io) base images:

- [`google/dart`][base]
- [`google/dart-runtime-base`][runtime-base]
- [`google/dart-runtime`][runtime]
- [`google/dart-hello`][hello]

## Deployment of a new version

The script `build_push.sh` will take care of building images and pushing to
them the official Docker registry.

To push a new version run the following command:

```
$ ./build_push.sh <namespace> <channel> <version>
```

For the official image use the namespace `google`. For testing use a
personal/temporary namespace. The version is the literal Dart version you
want to build and push, e.g. `1.9.3` or `2.10.0-1.0.dev`.

Push the official images for 1.9.3 like this:

```
$ ./build_push.sh google stable 1.9.3
```

The script will only push the `:latest` tag if the version is a stable
version. For developer and beta versions only the version tag will be pushed.

The script receives the Dart SDK from the official Debian [repository][1].
For the script to work the version you push must exist in the official
Debian repository.

NOTE: Any stable version will push the `:latest` tag, so beware
if building for an older stable version.

NOTE: Even though the script will only push the `:latest` tag for
stable versions the `:latest` tag in the local repository is updated
when building and pushing developer versions.

## Local testing

The `build_push.sh` script can also be used for testing the images. Just pass
a namespace you don't have access to (e.g. `google_test`). Then all the images
will be build locally, but the push to hub.docker.com will fail.

For testing with a custom build of Dart where an already built Dart .deb file
is used the script `build_custom.sh` can be used.

[base]: https://registry.hub.docker.com/u/google/dart/
[runtime-base]: https://registry.hub.docker.com/u/google/dart-runtime-base/
[runtime]: https://registry.hub.docker.com/u/google/dart-runtime/
[hello]: https://registry.hub.docker.com/u/google/dart-hello/
[1]: https://dart.dev/get-dart#install-a-debian-package
