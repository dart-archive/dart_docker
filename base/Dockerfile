# Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.
FROM google/debian:wheezy

ENV DART_VERSION 1.7.2
ENV DART_PACKAGE dart_$DART_VERSION-1_amd64.deb
ENV DART_REVISION 41096

RUN apt-get -q update && apt-get install --no-install-recommends -y -q curl
RUN curl -q -O http://storage.googleapis.com/dart-archive/channels/stable/release/$DART_REVISION/linux_packages/debian_wheezy/$DART_PACKAGE && dpkg -i $DART_PACKAGE && rm $DART_PACKAGE

ENV PATH /usr/lib/dart/bin:$PATH
