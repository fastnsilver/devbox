FROM fans/scala
MAINTAINER Chris Phillipson fastnsilver@gmail.com

RUN apt-get update
RUN apt-get install -y git curl build-essential make gcc wget

ENV VERSION 0.8.1.1
RUN wget http://apache.mirrors.pair.com/kafka/$VERSION/kafka_2.10-$VERSION.tgz && \
    tar xzvf kafka_2.10-$VERSION.tgz && \
    rm -f kafka_2.10-$VERSION.tgz && \
    mv kafka_2.10-$VERSION kafka && \
    mv kafka /opt/kafka && \
    cd /opt/kafka && sbt update && sbt package

RUN mkdir /data && mkdir /logs

ADD kafka-start.sh /opt/kafka/kafka-start.sh

ENV JMX_PORT 7203

VOLUME [ "/data" ]
VOLUME [ "/logs" ]

# primary
EXPOSE 9092
# jmx
EXPOSE 7203

CMD ["/opt/kafka/kafka-start.sh"]
