# google/dart-runtime

[`google/dart-runtime`][3] is a [docker](https://docker.io) base image that
makes it easy to dockerize a standard [Dart](https://dart.dev) application.

It can automatically bundle a Dart application and its dependencies with
a single line Dockerfile.

It is based on the [`google/dart-runtime-base`][2] base image.

## Usage

Create a `Dockerfile` in your Dart application directory with the following
content:

    FROM google/dart-runtime

To build a docker image tagged with `my/app` run:

    docker build -t my/app .

To run this image in a container (assuming it is a server application
listening on port 8080):

    docker run -d -p 8080:8080 my/app

## Sample

See the [sources](/hello) for [`google/dart-hello`][4] based on this image.

## Notes

The image assumes that your application:

- has the `pubspec.yaml` file listing its dependencies.
- has a file named `bin/server.dart` as the entrypoint script.
- listens on port `8080`
- all dependent packages can be retrieved when building the container

If you have package dependencies which do not meet the last requirement
take a look at using either the base image [`google/dart-runtime-base`][2]
or [`google/dart`][1].

### Example directory laoyout:

    bin
      server.dart
    packages
      ...
    pubspec.yaml

When building your application docker image, `ONBUILD` triggers fetch the
dependencies listed in the `pubspec.yaml` file and cache them appropriatly.

## Accessing the Observatory

The `dart-runtime` image enables the
[Observatory](https://dart-lang.github.io/observatory/) for the Dart
VM running in the container. The Observatory is listening on the default
port 8181. Just map that port to the host when running the app:

    docker run -d -p 8080:8080 -p 8181:8181 my-app

If using boot2docker you can access the Observatory using the docker
host network on http://192.168.59.103:8181/ (replacing 192.168.59.103
with what you 'boot2docker ip' says).

## Passing VM flags

The `dart-runtime` image can receive options for the Dart VM through
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
