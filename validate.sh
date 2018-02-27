#/bin/zsh

echo -e  "# Get a list of topics \x1B[94m"
curl "http://localhost:29080/topics"
echo -e "\x1B[39m"

echo -e "# Produce a message with JSON data \x1B[94m"
curl -X POST -H "Content-Type: application/vnd.kafka.json.v2+json" \
          --data '{"records":[{"value":{"name": "testUser"}}]}' \
          "http://localhost:29080/topics/jsontest"
echo -e "\x1B[39m"

echo -e "# Get info about one topic \x1B[94m"
curl "http://localhost:29080/topics/jsontest"
echo -e "\x1B[39m"

echo -e "# Create a consumer for JSON data, starting at the beginning of the topic's log. The consumer group is called \"my_json_consumer\" and the instance is \"my_consumer_instance\  \x1B[94m".
curl -X POST -H "Content-Type: application/vnd.kafka.v2+json" -H "Accept: application/vnd.kafka.v2+json" \
--data '{"name": "my_consumer_instance", "format": "json", "auto.offset.reset": "earliest"}' \
http://localhost:29080/consumers/my_json_consumer
echo -e "\x1B[39m"


echo -e "# Subscribe the consumer to a topic  \x1B[94m"
curl -X POST -H "Content-Type: application/vnd.kafka.v2+json" --data '{"topics":["jsontest"]}' \
http://localhost:29080/consumers/my_json_consumer/instances/my_consumer_instance/subscription
echo -e "No content in response\x1B[39m"


echo -e "# Then consume some data from a topic using the base URL in the first response.  \x1B[94m"
curl -X GET -H "Accept: application/vnd.kafka.json.v2+json" \
http://localhost:29080/consumers/my_json_consumer/instances/my_consumer_instance/records
echo -e "\x1B[39m"


echo -e "# Finally, close the consumer with a DELETE to make it leave the group and clean up its resources.   \x1B[94m"
curl -X DELETE -H "Accept: application/vnd.kafka.v2+json" \
      http://localhost:29080/consumers/my_json_consumer/instances/my_consumer_instance
echo -e "No content in response\x1B[39m"
