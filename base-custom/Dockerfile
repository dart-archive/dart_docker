# Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.
FROM gcr.io/google-appengine/debian10

RUN apt-get -q update && apt-get install --no-install-recommends -y -q curl git ca-certificates apt-transport-https
ADD dart.deb .
RUN dpkg -i dart.deb && rm dart.deb

ENV DART_SDK /usr/lib/dart
ENV PATH $DART_SDK/bin:/root/.pub-cache/bin:$PATH
