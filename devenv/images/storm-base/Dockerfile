FROM fans/oracle-java8
MAINTAINER Chris Phillipson fastnsilver@gmail.com

# apt
RUN apt-get update
RUN apt-get install -y git curl build-essential make gcc wget libtool autoconf automake uuid-dev pkg-config

#zero mq
ENV ZEROMQ_VERSION 4.0.5
RUN wget http://download.zeromq.org/zeromq-$ZEROMQ_VERSION.tar.gz
RUN tar -xzf zeromq-*.tar.gz
RUN cd zeromq-$ZEROMQ_VERSION && ./configure && make && make install

#JZMQ
RUN git clone https://github.com/nathanmarz/jzmq.git
RUN cd jzmq/src && touch classdist_noinst.stamp && CLASSPATH=.:./.:$CLASSPATH javac -d . org/zeromq/ZMQ.java org/zeromq/ZMQException.java org/zeromq/ZMQQueue.java org/zeromq/ZMQForwarder.java org/zeromq/ZMQStreamer.java
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
RUN cd jzmq && ./autogen.sh && ./configure && make && make install

#storm
ENV STORM_VERSION 0.9.3
RUN wget http://apache.mirrors.pair.com/incubator/storm/apache-storm-$STORM_VERSION-incubating/apache-storm-$STORM_VERSION-incubating.tar.gz
RUN tar -xzf apache-storm-*.tar.gz
RUN ln -sfn apache-storm-$STORM_VERSION-incubating storm

ADD storm.log.properties /storm/log4j/storm.log.properties

CMD ["storm/storm"]
