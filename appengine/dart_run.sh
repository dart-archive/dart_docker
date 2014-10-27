#!/bin/bash

DBG_OPTION=
# Only enable Dart debugger in development mode.
if [ -n "$DBG_ENABLE" ] && [ "$GAE_PARTITION" = "dev" ]; then
  echo "Enabling Dart debugger"
  DBG_OPTION="--debug:${DBG_PORT:-5858}/0.0.0.0"
  echo $DBG_OPTION
fi

/usr/bin/dart \
     ${DBG_OPTION} \
     --enable-vm-service:8181/0.0.0.0 \
     ${DART_VM_OPTIONS} \
     /app/bin/server.dart
