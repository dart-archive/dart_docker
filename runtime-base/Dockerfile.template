# Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.
#
# Dockerfile for google/dart-runtime-base

FROM {{NAMESPACE}}/dart

ADD dart_run.sh /dart_runtime/
RUN chmod 755 /dart_runtime/dart_run.sh && \
  chown root:root /dart_runtime/dart_run.sh

ENV PORT 8080

# Expose ports for debugger (5858), application traffic ($PORT)
# and the observatory (8181)
EXPOSE $PORT 8181 5858

CMD []
ENTRYPOINT ["/dart_runtime/dart_run.sh"]
