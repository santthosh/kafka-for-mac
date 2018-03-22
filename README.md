# kafka-for-mac

For those who use macOS and docker, it can be quite challenging to get several Confluent Kafka components up and running. Support for Docker on macOS / Windows is not yet available as per Confluent. This repo is an attempt to remove the uncertainty and let people experiment with Confluent Kafka faster. Here are some references for you to understand why this challenging

[I can't connect to Kafka on OS X](https://github.com/confluentinc/cp-docker-images/issues/265)

[Note: Important Caveat - Images Not Tested for Docker for Mac or Windows](https://github.com/confluentinc/cp-docker-images)

[Networking features in Docker for Mac](https://docs.docker.com/docker-for-mac/networking/)

## Pre-requisites

As of this writing, my local is running

`Docker version 17.12.0-ce, build c97c6d6r`

## Getting Started

This docker-compose file has all the components necessary to bring up single node / single broker Kafka cluster,

* Zookeeper
* Kafka Broker
* Schema Registry
* Kafka REST Proxy

### Bootstrap

`docker-compose up -d`

You should see some results like this

```
Creating kafkaformac_kafka_1           ... done
Creating kafkaformac_zookeeper_1       ...
Creating kafkaformac_schema-registry_1 ... done
Creating kafkaformac_schema-registry_1 ...
Creating kafkaformac_kafka-rest_1      ... done
```

### Ensure the processes are running

`docker-compose ps`

You should see some results like this
```
            Name                         Command            State                           Ports
--------------------------------------------------------------------------------------------------------------------------
kafkaformac_kafka-rest_1        /etc/confluent/docker/run   Up      0.0.0.0:29080->29080/tcp, 8082/tcp
kafkaformac_kafka_1             /etc/confluent/docker/run   Up      0.0.0.0:29092->29092/tcp, 9092/tcp
kafkaformac_schema-registry_1   /etc/confluent/docker/run   Up      0.0.0.0:29081->29081/tcp, 8081/tcp
kafkaformac_zookeeper_1         /etc/confluent/docker/run   Up      2181/tcp, 2888/tcp, 0.0.0.0:32181->32181/tcp, 3888/tcp
```

Check the health of zookeeper by monitoring its logs through this command

`docker-compose logs zookeeper | grep -i binding`

Check if the kafka broker is healthy

`docker-compose logs kafka | grep -i started`

Similarly inspect logs for schema-registry and kafka-rest

`docker-compose logs schema-registry`

`docker-compose logs kafka-rest`

### Consuming and Producing using the Kafka clients
* Add a mapping with your machine ip to  `docker.for.mac.host.internal` to your `/etc/hosts` file
  * e.g. `10.0.4.162      docker.for.mac.host.internal`
  * find your machine ip with `ifconfig | grep -e "inet "`
  * (!) your machine ip changes if you change network, update the config and restart the container
* Connect to the kafka cluster via `localhost:29092` (bootstrap server)

### Publishing and Subscribing using Kafka REST

[confluentinc/kafka-rest](https://github.com/confluentinc/kafka-rest) has full documentation around this, but the validate.sh script allows you to run all the same quickly, go ahead and run it

`./validate.sh`

You should see the RESTful endpoints invoked in sequence for publishing and subscribing from your Kafka

```
# Get a list of topics
["_schemas","jsontest"]
# Produce a message with JSON data
{"offsets":[{"partition":0,"offset":6,"error_code":null,"error":null}],"key_schema_id":null,"value_schema_id":null}
# Get info about one topic
{"name":"jsontest","configs":{"file.delete.delay.ms":"60000","segment.ms":"604800000","min.compaction.lag.ms":"0","retention.bytes":"-1","segment.index.bytes":"10485760","cleanup.policy":"delete","follower.replication.throttled.replicas":"","message.timestamp.difference.max.ms":"9223372036854775807","segment.jitter.ms":"0","preallocate":"false","segment.bytes":"1073741824","message.timestamp.type":"CreateTime","message.format.version":"0.11.0-IV2","max.message.bytes":"1000012","unclean.leader.election.enable":"false","retention.ms":"604800000","flush.ms":"9223372036854775807","delete.retention.ms":"86400000","leader.replication.throttled.replicas":"","min.insync.replicas":"1","flush.messages":"9223372036854775807","compression.type":"producer","min.cleanable.dirty.ratio":"0.5","index.interval.bytes":"4096"},"partitions":[{"partition":0,"leader":1,"replicas":[{"broker":1,"leader":true,"in_sync":true}]}]}
# Create a consumer for JSON data, starting at the beginning of the topic's log. The consumer group is called "my_json_consumer" and the instance is "my_consumer_instance\  .
{"instance_id":"my_consumer_instance","base_uri":"http://kr-host:8082/consumers/my_json_consumer/instances/my_consumer_instance"}
# Subscribe the consumer to a topic
No content in response
# Then consume some data from a topic using the base URL in the first response.
[]
# Finally, close the consumer with a DELETE to make it leave the group and clean up its resources.
No content in response
```

### Tear down

`docker-compose down`

## Caveats

* You really don't want bridge network on your docker compose, while its not well documented on why, its advised so. [confluentinc/cp-docker-images](https://github.com/confluentinc/cp-docker-images/wiki/Getting-Started)

## Contributing

Fork this repository, send in a pull request
