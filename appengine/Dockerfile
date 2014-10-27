# Base Dockerfile for Dart on App Engine Managed VMs.
FROM google/dart

ADD dart_run.sh /dart_runtime/
RUN chmod 755 /dart_runtime/dart_run.sh && \
  chown root:root /dart_runtime/dart_run.sh

# Expose ports for debugger (5858), application traffic (8080)
# and the observatory (8181)
EXPOSE 5858 8080 8181

WORKDIR /app
ENTRYPOINT ["/dart_runtime/dart_run.sh"]
