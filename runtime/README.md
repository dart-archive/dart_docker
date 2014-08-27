# google/dart-runtime

[`google/dart-runtime`](https://index.docker.io/u/google/dart-runtime)
is a [docker](https://docker.io) base image that makes it easy to dockerize
standard [Dart](https://dartlang.org) application.

It can automatically bundle a Dart application and its dependencies with
a single line Dockerfile.

It is based on [`google/dart`](https://index.docker.io/u/google/dart) base
image.

## Usage

Create a `Dockerfile` in your Dart application directory with the following
content:

    FROM google/dart-runtime

To build the a docker image tagged with `my-app` run:

    docker build -t my-app .

To run this image in a container (assuming it is a server application
listening in port 8080):

    docker run -d -p 8080:8080 my-app

## Sample

See the [sources](/hello) for
[`google/dart-hello`](https://index.docker.io/u/google/dart-hello) based
on this image.

## Notes

The image assumes that your application:

- has a the `pubspec.yaml` and `pubspec.lock` files listing its dependencies.
- has a file named `bin/server.dart` as the entrypoint script.
- listens on port `8080`

### Example directory laoyout:

    bin
      server.dart
    packages
      ...
    pubspec.lock
    pubspec.yaml

When building your application docker image, `ONBUILD` triggers fetch the
dependencies listed in `pubspec.yaml` and `pubspec.yaml` and cache them
appropriatly.
