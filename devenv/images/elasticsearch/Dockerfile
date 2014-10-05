FROM fans/oracle-java8

# elasticsearch
RUN apt-get update
RUN apt-get install -y git curl build-essential make gcc wget

ENV VERSION 1.3.4
RUN wget --no-check-certificate https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-$VERSION.tar.gz
RUN tar -xf elasticsearch-$VERSION.tar.gz
RUN rm elasticsearch-$VERSION.tar.gz
RUN ln -sfn elasticsearch-$VERSION elasticsearch
RUN elasticsearch/bin/plugin -u https://github.com/downloads/jprante/elasticsearch-analysis-naturalsort/elasticsearch-analysis-naturalsort-1.0.0.zip -install elasticsearch-analysis-naturalsort
RUN elasticsearch/bin/plugin -install mobz/elasticsearch-head
RUN elasticsearch/bin/plugin -install lukas-vlcek/bigdesk

RUN mkdir /data
RUN mkdir /logs

VOLUME [ "/logs" ]
VOLUME [ "/data" ]

EXPOSE 9200
EXPOSE 9300

CMD ["elasticsearch/bin/elasticsearch", "-f", "-D", "es.path.logs=/logs", "-D", "es.path.data=/data", "-D", "es.network.publish_host=127.0.0.1", "-D", "es.cluster.name=search-localhost" ]
