FROM google/debian:wheezy

ADD https://storage.googleapis.com/dart-archive/channels/stable/release/39553/linux_packages/debian_wheezy/dart_1.6.0-1_amd64.deb dart_1.6.0-1_amd64.deb
RUN dpkg -i dart_1.6.0-1_amd64.deb && rm dart_1.6.0-1_amd64.deb

ENV PATH /usr/lib/dart/bin:$PATH
