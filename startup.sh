#!/bin/bash

# Starting nginx with kibana
echo "Starting nginx..."
echo "nginx -c /etc/nginx/nginx.conf &"
nginx -c /etc/nginx/nginx.conf &

# Start Logstash
echo "Starting Logstash..."
echo "/logstash/bin/logstash agent --config /conf/logstash.conf &"
/logstash/bin/logstash agent --config /conf/logstash.conf &

# Starting Elsaticsearch
echo "Starting Elsaticsearch..."
echo "/elasticsearch/bin/elasticsearch"
/elasticsearch/bin/elasticsearch