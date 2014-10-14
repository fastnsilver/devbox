#!/bin/bash

echo "Fixing hostname"
HOST=`hostname`
echo "127.0.0.1 $HOST" >> /etc/hosts

echo "Starting kafka"
/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties > /logs/kafka.log 2>&1
