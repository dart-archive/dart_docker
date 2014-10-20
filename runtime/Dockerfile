# Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.
FROM google/dart:1.7.2

ADD dart_run.sh /dart_runtime/
RUN chmod 755 /dart_runtime/dart_run.sh
RUN chown root:root /dart_runtime/dart_run.sh

WORKDIR /app

ONBUILD ADD pubspec.yaml /app/
ONBUILD ADD pubspec.lock /app/
ONBUILD RUN pub get
ONBUILD ADD . /app/
ONBUILD RUN pub get

CMD []
ENTRYPOINT ["/dart_runtime/dart_run.sh"]
EXPOSE 8080 8181 5858
