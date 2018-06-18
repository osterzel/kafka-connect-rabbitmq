FROM confluentinc/cp-kafka-connect-base:4.0.0

RUN pip install envtpl

COPY target /opt/target
COPY target/kafka-connect-target/usr/share/kafka-connect/kafka-connect-rabbitmq/* /usr/share/java/kafka/ 
COPY config-templates /opt/config-templates
COPY docker-entrypoint.sh /opt
RUN chmod +x /opt/docker-entrypoint.sh

WORKDIR /opt

CMD [ "./docker-entrypoint.sh" ]
