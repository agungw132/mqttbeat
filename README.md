# docker-elasticsearch-mqttbeat
This beat will allow you to put MQTT messages in an elasticsearch instance.

## How to run the docker container
'''
docker run -d --restart unless-stopped --name mqttbeat -v ~/Dropbox/mqttbeat/mqttbeat.yml:/etc/mqttbeat/mqttbeat.yml agungw132/es-mqttbeat
'''
