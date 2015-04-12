FROM java:7
MAINTAINER mladen.cikara@gmail.com


# Setting versions
ENV ES_VERSION 1.5.1
ENV KIBANA_VERSION 4.0.1
ENV LOGSTASH_VERSION 1.4.2 

# Installing web server
RUN apt-get update && apt-get install -y nginx-full

# Install elasticsearch
RUN   cd /tmp && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-$ES_VERSION.tar.gz && \
  tar xvzf elasticsearch-$ES_VERSION.tar.gz && \
  rm -f elasticsearch-$ES_VERSION.tar.gz && \
  mv /tmp/elasticsearch-$ES_VERSION /elasticsearch

# Installing Kibana	3
# https://download.elasticsearch.org/kibana/kibana/kibana-$KIBANA_VERSION.zip
RUN cd /tmp && \
    wget -nv https://download.elasticsearch.org/kibana/kibana/kibana-$KIBANA_VERSION.tar.gz && \
    tar xvzf kibana-$KIBANA_VERSION.tar.gz && \
    rm -f kibana-$KIBANA_VERSION.tar.gz && \
    mv /tmp/kibana-$KIBANA_VERSION /usr/share/nginx/html/kibana

# Installing Logstash  
RUN cd /tmp && \
	wget -nv https://download.elasticsearch.org/logstash/logstash/logstash-$LOGSTASH_VERSION.tar.gz && \
	tar xvzf logstash-$LOGSTASH_VERSION.tar.gz && \
	rm -f logstash-$LOGSTASH_VERSION.tar.gz && \
    mv /tmp/logstash-$LOGSTASH_VERSION /logstash  

# Copynig config file that sets /data directory
ADD elasticsearch.yml /elasticsearch/config/elasticsearch.yml

# Installing elasticsearch-HQ plugin
RUN   cd /elasticsearch/bin &&\
		./plugin -install royrusso/elasticsearch-HQ

# Configure nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Install contrib plugins
RUN cd /logstash &&\
	./bin/plugin install contrib

# Copying files
COPY  startup.sh /scripts/
COPY  logstash.conf /conf/

RUN cd /scripts && \
	chmod +x startup.sh

# Expose the PostgreSQL port
EXPOSE 9200 9300 80

# Add VOLUMEs to allow backup of config, logs and databases
# VOLUME  ["/data", "/etc/nginx/", "/logstash", "/scripts", "/conf", "/var/log"]
VOLUME  ["/var/log/postgresql"]

# Set the default command to run when starting the container
CMD ["./scripts/startup.sh"]