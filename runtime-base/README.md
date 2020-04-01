# google/dart-runtime-base

[`google/dart-runtime-base`][2] is a [docker](https://docker.io) base image that
makes it easy to dockerize a standard [Dart](https://dart.dev) application
which is using local packages.

If you have a Dart application which does not require local packages you
might be able to use the base image [`google/dart-runtime`][3] which is
simpler.

Using this image requires that a predefined directory layout is used together
with a `Dockerfile` following a predefined template.

It is based on the [`google/dart`][1] base image.

If the directory layout described below does not work for your setup a
`Dockerfile` based on the [`google/dart`][1] base image is probably the way
to go.

## Usage

The following directory layout is used:

    project
      Dockerfile
      app
        bin
          server.dart
        pubspec.yaml
      pkg
        my-package-1
        my-package-2

The top-level directory `project` contains the `Dockerfile` and the two
directories `app` and `pkg`. The `app` directory contains a Dart application
with the main entrypoint in `bin/server.dart`. The packages referred from
`app/pubspec.yaml` must be either packages on [pub.dev](https://pub.dev) or
packages in the `pkg` directory referred to using a relative `path` dependency,
like this:

    name: dart_app
    version: 0.1.0
    description: Dart application.
    dependencies:
      my-package-1:
        path: ../pkg/my-package-1
      my-package-2:
        path: ../pkg/my-package-2

You can also use `dependency_overrides` like this:

    name: dart_app
    version: 0.1.0
    description: Dart application.
    dependencies:
      some-package: any
    dependency_overrides:
      my-package-1:
        path: ../pkg/my-package-1
      my-package-2:
        path: ../pkg/my-package-2

Then create a `Dockerfile` in your Dart application directory with the
following content:

    FROM google/dart-runtime-base

    WORKDIR /project/app

    # Add the pubspec.yaml files for each local package.
    ADD pkg/my-package-1/pubspec.yaml /project/pkg/my-package-1/
    ADD pkg/my-package-2/pubspec.yaml /project/pkg/my-package-2/

    # Template for adding the application and local packages.
    ADD app/pubspec.* /project/app/
    RUN pub get
    ADD . /project
    RUN pub get --offline

Depending on your local packages you need to change the `ADD` commands in the
section after the comment _Add the pubspec.yaml files for each local package_.
Add an `ADD` command for each of your local packages. Be careful with adding
the terminating `/` for the `ADD` commands. The rest of the `Dockerfile`
should just be copied.

To build a docker image tagged with `my/app` run:

    docker build -t my/app .

To run this image in a container (assuming it is a server application
listening on port 8080):

    docker run -d -p 8080:8080 my/app

## Accessing the Observatory

The `dart-runtime-base` image enables the
[Observatory](https://dart-lang.github.io/observatory/) for the Dart VM running
in the container. The Observatory is listening on the default port 8181. Just
map that port to the host when running the app:

    docker run -d -p 8080:8080 -p 8181:8181 my-app

If using boot2docker you can access the Observatory using the docker
host network on http://192.168.59.103:8181/ (replacing 192.168.59.103
with what you 'boot2docker ip' says).

## Passing VM flags

The `dart-runtime-base` image can receive options for the Dart VM through
the environment variable `DART_VM_OPTIONS`.

    docker run -d -p 8080:8080 \
        --env DART_VM_OPTIONS='--old_gen_heap_size=2048 --verbose-gc' \
        my/app

## Using this image with App Engine Managed VMs

If you are using this image with App Engine Managed VMs, the `app.yaml`
file must be alongside the `Dockerfile` in the project directory.

You can set up Observatory access by adding the following to the
`app.yaml` file:

    network:
      forwarded_ports: ["8181"]

You can pass VM flags by adding the following to the `app.yaml` file:

    env_variables:
      DART_VM_OPTIONS: --old_gen_heap_size=2048 --verbose-gc


[1]: https://hub.docker.com/r/google/dart
[2]: https://hub.docker.com/r/google/dart-runtime-base
[3]: https://hub.docker.com/r/google/dart-runtime
[4]: https://hub.docker.com/r/google/dart-hello
