dart_docker
===========

This repository contains the sources for the following
[docker](https://docker.io) base images:

- [`google/dart`](/base)
- [`google/dart-appengine`](/appengine)
- [`google/dart-runtime`](/runtime)
- [`google/dart-hello`](/hello)

## Deployment of a new version

The script `build-push.sh` will take care of building images and pushing to
the official Docker registry.

To push a new version do the following:

1. Update `VERSION` in `build-push.sh`

2. Run `build-push.sh`

If you want to dry-run using another namespace than `google` you can
change `NAMESPACE` in `build-push.sh` before runnning it.

The script will only push the `:latest` tag if the version is a stable
version. For developer versions only the version tag vill be pushed.

NOTE: Any stable version will push the `:latest` tag, so beware
if building for an older stable version.

NOTE: Even though the script will only push the `:latest` tag for
stable versions the `:latest` tag in the local repository is updated
when building and pushing developer versions.

### Deprecated procedure - remove when the above is in place

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

8. Setup new branch with Dockerfiles using the versioned images

  * Create a new branch on GitHub with the same name as the version
  * Check out that branch

    $ git branch xxx origin/1.8.3
    $ git checkout xxx

  * Add `:<version>` to the `FROM` line in the `Dockerfile` in
    `runtime-base`, `runtime` and `hello`.
  * Push the change to the branch.

    $ git push

9. Setup automatic build for the branch

  * Open [https://registry.hub.docker.com/u/google/dart-runtime-base/][1].
  * Under _Settings_ go to _Automated Build_.
  * Setup an additional automated build.
  * Repeat for `runtime` and `hello`.

10. At some point get rid of this procedure, and push the local builds instead
of using hub.docker.com automated builds

## Local testing

For testing the images the script `build.sh` can be used. It will build the
images locally in the `google_test` namespace. Note when using this script the
`Dockerfile`s need to be changed to be based on the `google_test` namespace.

For testing with a custom build of Dart where an already built Dart .deb file
is used the script `build_custom.sh` can be used.

[1]
