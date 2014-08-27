# google/dart-hello

[`google/dart-hello`](https://index.docker.io/u/google/dart-hello) is a
[docker](https://docker.io) image for a simple Dart HTTP server.

It is based on
[`google/dart-runtime`](https://index.docker.io/u/google/dart-runtime)
base image and listen on port `8080`.

## Run the Dart HTTP server in the docker container

Run the following command to start the server application:

    docker run -d -p 8080:8080 google/dart-hello

## Access the server

If you are using boot2docker you need to access the server on the
doot2docker host network. The command `boot2docker ip` will give the
hosts address on that network.

    curl http://`boot2docker ip 2> /dev/null`:8080/version

If you are running the docker daemon directly on a Linux host you can
access the server on `localhost`

    curl http://localhost:8080/version
