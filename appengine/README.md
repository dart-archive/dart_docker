# google/dart-appengine

[`google/dart-appengine`](https://index.docker.io/u/google/dart-appengine)
is a [docker](https://docker.io) base image for running Dart on App Engine
Managed VMs.

It is based on the [`google/dart`](https://index.docker.io/u/google/dart) base
image.

## Usage

Create a `Dockerfile` in your Dart App Engine application directory with the
following content:

    FROM google/dart-appengine
    ADD . /app/

Then you can run your Dart App Engine application

    $ gcloud preview app run <path-to app.yaml>

and deploy it

    $ gcloud preview app deploy <path-to app.yaml> \
        --server preview.appengine.google.com

