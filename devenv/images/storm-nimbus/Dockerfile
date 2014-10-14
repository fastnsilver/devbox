FROM fans/storm-base
MAINTAINER Chris Phillipson fastnsilver@gmail.com

ADD storm.yaml /storm/conf/storm.yaml
ADD storm_util.sh /storm/storm_util.sh
ADD storm-nimbus-start.sh storm/storm-nimbus-start.sh

# vols
RUN mkdir /data
RUN mkdir /logs
RUN mkdir /init
VOLUME [ "/logs" ]
VOLUME [ "/data" ]
VOLUME [ "/init" ]

EXPOSE 6627

CMD ["storm/storm-nimbus-start.sh"]
