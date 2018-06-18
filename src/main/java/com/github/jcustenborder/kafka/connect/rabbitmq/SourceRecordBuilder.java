/**
 * Copyright © 2017 Jeremy Custenborder (jcustenborder@gmail.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.github.jcustenborder.kafka.connect.rabbitmq;

import com.google.common.collect.ImmutableMap;
import com.rabbitmq.client.AMQP;
import com.rabbitmq.client.Envelope;
//import org.apache.kafka.common.protocol.types.Schema;
import org.apache.kafka.common.utils.SystemTime;
import org.apache.kafka.common.utils.Time;
import org.apache.kafka.connect.data.Struct;
import org.apache.kafka.connect.source.SourceRecord;

class SourceRecordBuilder {
  final RabbitMQSourceConnectorConfig config;
  Time time = new SystemTime();

  SourceRecordBuilder(RabbitMQSourceConnectorConfig config) {
    this.config = config;
  }

  SourceRecord sourceRecord(String consumerTag, Envelope envelope, AMQP.BasicProperties basicProperties, byte[] bytes) {
    Struct key = MessageConverter.key(basicProperties);
    Struct value = MessageConverter.value(consumerTag, envelope, basicProperties, bytes);
    final String topic = this.config.kafkaTopic.execute(RabbitMQSourceConnectorConfig.KAFKA_TOPIC_TEMPLATE, value);
    String messageBody = value.getString("body");

    return new SourceRecord(
        ImmutableMap.of("routingKey", envelope.getRoutingKey()),
        ImmutableMap.of("deliveryTag", envelope.getDeliveryTag()),
        topic,
        null,
        key.schema(),
        key,
        org.apache.kafka.connect.data.Schema.STRING_SCHEMA,
        messageBody,
        null == basicProperties.getTimestamp() ? this.time.milliseconds() : basicProperties.getTimestamp().getTime()
    );
  }
}
