FROM phusion/baseimage
MAINTAINER Chris Phillipson fastnsilver@gmail.com

# Install Python
RUN \
  apt-get update; \
  apt-get install -y python wget;

ENV VERSION 5.0.1
# Download and extract OpsCenter
RUN \
  mkdir /opt/opscenter; \
  wget -O - http://downloads.datastax.com/community/opscenter-$VERSION.tar.gz \
  | tar xzf - --strip-components=1 -C "/opt/opscenter";

ADD	. /src

# Copy over daemons
RUN	\
  mkdir -p /etc/service/opscenter; \
  cp /src/run /etc/service/opscenter/;

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose ports
EXPOSE 8888

WORKDIR /opt/opscenter

CMD ["/sbin/my_init"]
