FROM fns/oracle-java8

RUN apt-get update
RUN apt-get install -y git curl build-essential make gcc wget

ENV VERSION 3.4.6
RUN wget http://apache.mirrors.tds.net/zookeeper/zookeeper-$VERSION/zookeeper-$VERSION.tar.gz
RUN tar xzf zookeeper-$VERSION.tar.gz

ADD zoo.cfg /zookeeper-$VERSION/conf/zoo.cfg
ADD log4j.properties /zookeeper-$VERSION/conf/log4j.properties

VOLUME [ "/data" ]
VOLUME [ "/logs" ]

EXPOSE 2181

CMD ["zookeeper-$VERSION/bin/zkServer.sh", "start-foreground"]
