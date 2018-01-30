kafka-connect-rabbitmq-jar:
	docker run -t -i -v $(PWD):/data --workdir /data maven:3.5.2-jdk-8-slim mvn package

kafka-connect-rabbitmq-docker:
	docker build -t kafka-connect-rabbitmq .

kafka-connect-compose:
	docker-compose up --build

kafka-create-connector:
	curl -X PUT -H 'Content-type: application/json' localhost:28082/connectors/rabbitmq-node1/config -d @config/distributed-rabbitmq-source.json
	curl -X POST localhost:28082/connectors/rabbitmq-node1/restart
