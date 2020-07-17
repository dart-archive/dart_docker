# google/dart-hello-browser

[`google/dart-hello-browser`](https://hub.docker.com/r/google/dart-hello-browser)
is a [Docker](https://docker.io) image to show a web test inside a browser.

It is based on
[`google/dart-browser`](https://hub.docker.com/r/google/dart-browser)
base image, that runs tests inside
[Firefox-ESR](https://www.mozilla.org/).

## Run the Web Application tests

Build and run the Docker image:

    docker build -t test/dart-hello-browser .
    
    docker run -t test/dart-hello-browser 

The default `ENTRYPOINT` will run the test at `hello_browser_test.dart`
inside `firefox`.

You can explicitly pass a command to the Docker image:

    docker run -t test/dart-hello-browser pub run test -p firefox
