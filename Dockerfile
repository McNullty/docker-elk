#
# example Dockerfile for http://docs.docker.com/examples/postgresql_service/
#

FROM java:7
MAINTAINER mladen.cikara@gmail.com


# Setting versions
ENV ES_VERSION 1.3.4
ENV KIBANA_VERSION 3.1.1

# Install elasticsearch
RUN   cd /tmp && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-$ES_VERSION.tar.gz && \
  tar xvzf elasticsearch-$ES_VERSION.tar.gz && \
  rm -f elasticsearch-$ES_VERSION.tar.gz && \
  mv /tmp/elasticsearch-$ES_VERSION /elasticsearch

ADD elasticsearch.yml /elasticsearch/config/elasticsearch.yml

# Installing elasticsearch-HQ plugin
RUN   cd /elasticsearch/bin &&\
		./plugin -install royrusso/elasticsearch-HQ

# Installing Kibana	3
# https://download.elasticsearch.org/kibana/kibana/kibana-$KIBANA_VERSION.zip

# Expose the PostgreSQL port
EXPOSE 9200 9300

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/data"]

# Set the default command to run when starting the container
CMD ["/elasticsearch/bin/elasticsearch"]