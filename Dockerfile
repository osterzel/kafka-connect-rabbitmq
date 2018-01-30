FROM confluentinc/cp-kafka-connect-base:4.0.0

COPY target /opt/target
COPY target/kafka-connect-target/usr/share/kafka-connect/kafka-connect-rabbitmq/* /usr/share/java/kafka/ 
COPY config /opt/config
COPY config/RabbitMQSourceConnector.properties /etc/kafka/

WORKDIR /opt

#CMD [ "connect-standalone", "config/connect-avro-docker.properties", "config/RabbitMQSourceConnector.properties" ]
