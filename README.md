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

### Publishing and Subscribing using Kafka REST

[confluentinc/kafka-rest](https://github.com/confluentinc/kafka-rest) has full documentation around this

### Tear down

`docker-compose down`

## Caveats

* You really don't want bridge network on your docker compose, while its not well documented on why, its advised so. [confluentinc/cp-docker-images](https://github.com/confluentinc/cp-docker-images/wiki/Getting-Started)

## Contributing

Fork this repository, send in a pull request
