FROM ubuntu:14.04
MAINTAINER Chris Phillipson fastnsilver@gmail.com

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y                             && \
    apt-get install software-properties-common -y && \
    add-apt-repository ppa:webupd8team/java -y    && \
    apt-get update -y
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install oracle-java8-installer -y
