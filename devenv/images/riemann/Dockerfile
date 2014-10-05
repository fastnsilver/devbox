FROM fans/oracle-java8

RUN apt-get update
RUN apt-get install -y wget bzip2

ENV VERSION 0.2.6
RUN wget http://aphyr.com/riemann/riemann-$VERSION.tar.bz2
RUN tar xvfj riemann-$VERSION.tar.bz2
RUN cd riemann-$VERSION

ADD riemann.config riemann-$VERSION/etc/riemann.config

#comms, web, repl
EXPOSE 5555, 5556, 5557

CMD ["riemann-$VERSION/bin/riemann", "riemann-$VERSION/etc/riemann.config"]
