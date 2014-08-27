FROM google/dart

WORKDIR /app
ONBUILD ADD pubspec.yaml /app/
ONBUILD ADD pubspec.lock /app/
ONBUILD RUN pub get
ONBUILD ADD . /app
ONBUILD RUN pub get

CMD []
ENTRYPOINT ["/usr/bin/dart", "/app/bin/server.dart"]
EXPOSE 8080
