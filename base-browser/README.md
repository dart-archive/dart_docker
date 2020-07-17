# google/dart-web

[`google/dart-browser`](https://hub.docker.com/r/google/dart-browser) is a
[docker](https://docker.com) base image that bundles the latest version
of the [Dart SDK](https://dart.dev), installed from
[dart.dev](https://dart.dev/get-dart), and 
[Firefox-ESR](https://www.mozilla.org/en-US/firefox/enterprise/),
installed from standard `apt-get` repositories.

## Usage

To configure Docker not to copy across `pub` generated files into the Docker
file system, create a `.dockerignore` with the following contents.

    # Files and directories created by pub
    .dart_tool/
    .packages
    .pub/
    build/

If you have a Web application directory with a `pubspec.yaml`,
you can create a `Dockerfile` in the application directory with the
following content:

    FROM google/dart

    WORKDIR /app

    ADD pubspec.* /app/
    RUN pub get
    ADD . /app

To build a docker image tagged with `my/web-app` run:

    docker build -t my/web-app .

To run this image in a container:

    docker run -i -t my/web-app

By default, the `ENTRYPOINT` will run `pub run test`, using the default
platform of your project.

You can pass any command to the image, and it will run the commands as
user `browser_user`:

    docker run -i -t my/web-app pub run test -p firefox

## Extending this image.

Is recommended to run any command using the user `browser_user`. You
can use the bundled command `run-as-browser_user` for that:

    RUN run-as-browser_user pub get

Also is recommended to respect ownership using:

    ADD --chown=browser_user:root some-file /app/
    # or
    RUN chown -R browser_user:root /app/



## Test Platform

To define your testing platform and the `firefox` platform, you should
have a `dart_test.yaml` file in your project.
 
By default, a `dart_test.yaml` is provided at `/app/dart_test.yaml`:
```yaml
concurrency: 1

override_platforms:
  chrome:
    settings:
      headless: true
  firefox:
    settings:
      arguments: -headless

define_platforms:
  firefox-esr:
    name: Firefox-ESR
    extends: firefox
    settings:
      executable:
        linux: firefox-esr

## Uncomment if you want 'firefox' as default testing platform
#platforms: [firefox]
```

If you need, you can select `firefox` as testing platform passing:

    pub run test -p firefox

## browser_user

Since most browsers won't allow execution from `root`, this images has the user `browser_user`.

Buy default this is the user used for execution of `ENTRYPOINT` or `CMD`.
