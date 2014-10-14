FROM fans/oracle-java8
MAINTAINER Chris Phillipson fastnsilver@gmail.com

RUN apt-get update
RUN apt-get install -y wget bzip2

ENV VERSION 0.2.6
RUN wget http://aphyr.com/riemann/riemann-$VERSION.tar.bz2 && \
    tar xvfj riemann-$VERSION.tar.bz2 && \
    mv riemann-$VERSION riemann && \
    mv riemann /opt/riemann

ADD riemann.config /opt/riemann/etc/riemann.config

EXPOSE 4567
EXPOSE 5555
EXPOSE 5556
EXPOSE 5557

CMD ["/opt/riemann/bin/riemann", "/opt/riemann/etc/riemann.config"]
