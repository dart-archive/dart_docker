FROM google/debian:wheezy

RUN apt-get -q update && apt-get install --no-install-recommends -y -q curl
RUN curl -q -O http://storage.googleapis.com/dart-archive/channels/stable/release/39553/linux_packages/debian_wheezy/dart_1.6.0-1_amd64.deb && dpkg -i dart_1.6.0-1_amd64.deb && rm dart_1.6.0-1_amd64.deb

ENV PATH /usr/lib/dart/bin:$PATH
