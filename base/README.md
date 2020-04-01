# google/dart

[`google/dart`](https://hub.docker.com/r/google/dart) is a
[docker](https://docker.com) base image that bundles the latest version
of the [Dart SDK](https://dart.dev) installed from
[dart.dev](https://dart.dev/get-dart).

It serves as a base for the
[`google/dart-runtime`](https://hub.docker.com/r/google/dart-runtime) image.

## Usage

To configure Docker not to copy across `pub` generated files into the Docker
file system, create a `.dockerignore` with the following contents.

    # Files and directories created by pub
    .dart_tool/
    .packages
    .pub/
    build/

If you have an application directory with a `pubspec.yaml` file and the
main application entry point in `main.dart` you can create a `Dockerfile`
in the application directory with the following content:

    FROM google/dart

    WORKDIR /app

    ADD pubspec.* /app/
    RUN pub get
    ADD . /app

    ENTRYPOINT ["/usr/bin/dart", "main.dart"]

To build a docker image tagged with `my/app` run:

    docker build -t my/app .

To run this image in a container:

    docker run -i -t my/app

However, if you application directory has a layout like this and potentially is
exposing a server at port 8080 you should consider using the base image
`google/dart-runtime` instead.
