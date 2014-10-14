FROM fans/oracle-java8
MAINTAINER Chris Phillipson fastnsilver@gmail.com

RUN apt-get update
RUN apt-get install -y git curl build-essential make gcc wget

ENV VERSION 2.1.0
RUN cd /opt && wget http://apache.mirrors.pair.com/cassandra/$VERSION/apache-cassandra-$VERSION-bin.tar.gz
RUN cd /opt && tar zxf apache-cassandra-*.tar.gz
RUN rm /opt/*.tar.gz
RUN mv /opt/apache-cassandra-* /opt/cassandra

RUN apt-get install -y lsof

ADD start.sh /opt/cassandra/bin/start.sh
RUN chmod 755 /opt/cassandra/bin/start.sh
RUN mkdir /data
RUN mkdir /logs
RUN mkdir /init

VOLUME [ "/init" ]
VOLUME [ "/logs" ]
VOLUME [ "/data" ]

EXPOSE 7000
EXPOSE 7001
EXPOSE 7199
EXPOSE 9160
EXPOSE 9042

CMD "/opt/cassandra/bin/start.sh"
