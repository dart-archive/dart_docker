# Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.
#
# Dockerfile for google/dart-runtime

FROM google/dart-runtime-base:1.8.0

WORKDIR /app

ONBUILD ADD pubspec.yaml /app/
ONBUILD ADD pubspec.lock /app/
ONBUILD RUN pub get
ONBUILD ADD . /app/
ONBUILD RUN pub get --offline
