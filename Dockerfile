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

# Copynig config file that sets /data directory
ADD elasticsearch.yml /elasticsearch/config/elasticsearch.yml

# Installing elasticsearch-HQ plugin
RUN   cd /elasticsearch/bin &&\
		./plugin -install royrusso/elasticsearch-HQ

# TODO: Pmaknuti na početak
# Installing web server
RUN apt-get update && apt-get install -y nginx-full

# Configure nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf


# Installing Kibana	3
# https://download.elasticsearch.org/kibana/kibana/kibana-$KIBANA_VERSION.zip
RUN cd /tmp && \
    wget -nv https://download.elasticsearch.org/kibana/kibana/kibana-$KIBANA_VERSION.tar.gz && \
    tar xvzf kibana-$KIBANA_VERSION.tar.gz && \
    rm -f kibana-$KIBANA_VERSION.tar.gz && \
    mv /tmp/kibana-$KIBANA_VERSION /usr/share/nginx/html

# Expose the PostgreSQL port
EXPOSE 9200 9300 80

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/data" , "/etc/nginx/"]

# Set the default command to run when starting the container
CMD /elasticsearch/bin/elasticsearch & nginx -c /etc/nginx/nginx.conf