FROM fans/oracle-java8
MAINTAINER Chris Phillipson fastnsilver@gmail.com

RUN apt-get update
RUN apt-get install -y git curl build-essential make gcc wget

ENV VERSION 3.4.6
RUN wget http://apache.mirrors.hoobly.com/zookeeper/zookeeper-$VERSION.tar.gz
RUN tar xzf zookeeper-$VERSION.tar.gz
RUN mv zookeeper-$VERSION /opt/zookeeper

ADD zoo.cfg /opt/zookeeper/conf/zoo.cfg
ADD log4j.properties /opt/zookeeper/conf/log4j.properties

VOLUME [ "/data" ]
VOLUME [ "/logs" ]

EXPOSE 2181

CMD ["/opt/zookeeper/bin/zkServer.sh", "start-foreground"]
