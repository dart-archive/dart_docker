# Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.
#
# Dockerfile for google/dart-runtime

FROM {{NAMESPACE}}/dart-runtime-base

WORKDIR /app

# In docker each step creates an image layer that is cached. We add the
# pubspec.* before "pub get", then we add the rest of /app/ and run
# "pub get --offline". Thus, rebuilding without touching pubspec.* files won't
# download all dependencies again (facilitating faster image rebuilds).
ONBUILD ADD pubspec.* /app/
ONBUILD RUN pub get
ONBUILD ADD . /app/
ONBUILD RUN pub get --offline
