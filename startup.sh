#!/bin/bash

# Starting nginx with kibana
echo "Starting nginx..."
nginx -c /etc/nginx/nginx.conf &

# Start Logstash
echo "Starting Logstash..."
/logstash/bin/logstash agent --config /conf/logstash.conf &

# Starting Elsaticsearch
echo "Starting Elsaticsearch..."
/elasticsearch/bin/elasticsearch