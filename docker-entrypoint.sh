#!/bin/sh

set -e

export KAFKA_BROKERS=${KAFKA_BROKERS:-kafka:9092}
export KAFKA_TOPIC=${KAFKA_TOPIC}
export RABBITMQ_HOST=${RABBITMQ_HOST:-rabbitmq}
export RABBITMQ_QUEUE=${RABBITMQ_QUEUE}

if [ -z $KAFKA_TOPIC ]; then
    echo "KAFKA_TOPIC not set exiting"
    exit 1
fi

if [ -z $RABBITMQ_QUEUE ]; then
    echo "RABBITMQ_QUEUE not set exiting"
    exit 1
fi

echo "Starting rabbitmq to kafka connect"
echo "Configuration:"
echo "==> Rabbitmq Host: $RABBITMQ_HOST"
echo "==> Rabbitmq Queue: $RABBITMQ_QUEUE"
echo "==> Kafka Brokers: $KAFKA_BROKERS"
echo "==> Kafka Topic: $KAFKA_TOPIC"
echo ""

# Parse through each config template and write out config file

[ ! -d /opt/config ] && mkdir -p /opt/config

cd /opt/config-templates
for TEMPLATE in *
do
    NAME=$(echo $TEMPLATE | awk -F '.tpl' '{print $1}')
    envtpl < $TEMPLATE > /opt/config/$NAME
done

cd /opt

CONFIG_FILES=$(find /opt/config/ -type f | tr '\n' ' ')

echo "Config files - $CONFIG_FILES"

connect-standalone config/connect-kafka-docker.properties config/RabbitMQSourceConnector.properties