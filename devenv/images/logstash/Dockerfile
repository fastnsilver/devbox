FROM fans/oracle-java8
MAINTAINER Chris Phillipson fastnsilver@gmail.com

RUN apt-get update
RUN apt-get install -y git curl build-essential make gcc wget

ENV VERSION 1.4.2
# Download logstash
RUN cd /tmp && \
    wget https://download.elasticsearch.org/logstash/logstash/logstash-$VERSION.tar.gz && \
    tar -xzvf logstash-$VERSION.tar.gz && \
    mv logstash-$VERSION /opt/logstash && \
    rm -f logstash-$VERSION.tar.gz

# Install contrib plugins
RUN /opt/logstash/bin/plugin install contrib

RUN cd /opt/logstash && \
  touch logstash.conf && \
	echo 'input { tcp { port => 3377 type => "text event"} tcp { port => 3374 type => "json event" codec => json_lines {} } }' >> logstash.conf && \
	echo 'output { elasticsearch { host => localhost } }' >> logstash.conf

EXPOSE 3377 3374

## FIXME Broken; won't start-up

# Start logstash
ENTRYPOINT ["/opt/logstash/bin/logstash agent -f /opt/logstash/logstash.conf"]
