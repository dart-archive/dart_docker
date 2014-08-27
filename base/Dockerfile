FROM google/debian:wheezy

ADD https://storage.googleapis.com/dart-archive/channels/stable/release/38663/linux_packages/debian_wheezy/dart_1.5.8-1_amd64.deb dart_1.5.8-1_amd64.deb
RUN dpkg -i dart_1.5.8-1_amd64.deb && rm dart_1.5.8-1_amd64.deb

ENV PATH /usr/lib/dart/bin:$PATH
