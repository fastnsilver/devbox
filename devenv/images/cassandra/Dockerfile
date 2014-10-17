FROM fans/oracle-java8
MAINTAINER Chris Phillipson fastnsilver@gmail.com

RUN apt-get update
RUN apt-get install -y wget python lsof

ENV CASSANDRA_VERSION 2.1.0
# Download and extract Cassandra
RUN cd /opt && wget http://apache.mirrors.pair.com/cassandra/$CASSANDRA_VERSION/apache-cassandra-$CASSANDRA_VERSION-bin.tar.gz && \
    tar zxf apache-cassandra-*.tar.gz && \
    rm /opt/*.tar.gz && \
    mv /opt/apache-cassandra-* /opt/cassandra

ENV DATASTAX_VERSION 5.0.1
# Download and extract DataStax OpsCenter Agent
RUN cd /opt && wget http://downloads.datastax.com/community/datastax-agent-$DATASTAX_VERSION.tar.gz && \
    tar zxf datastax-agent-*.tar.gz && \
    rm /opt/*.tar.gz && \
    mv /opt/datastax-agent-* /opt/agent

ADD	. /src

# Copy over daemons
RUN cp /src/cassandra.yaml /opt/cassandra/conf/ && \
    mkdir -p /etc/service/cassandra && \
    cp /src/cassandra-run /etc/service/cassandra/run && \
    mkdir -p /etc/service/agent && \
    cp /src/agent-run /etc/service/agent/run

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose ports
EXPOSE 7199 7000 7001 9160 9042

WORKDIR /opt/cassandra

CMD ["/sbin/my_init"]
