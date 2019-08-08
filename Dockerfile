FROM golang:alpine

RUN apk add --no-cache g++ glide git && \
mkdir -p /go/src/github.com/nathan-k-/ && \
cd /go/src/github.com/nathan-k-/ && \
git clone https://github.com/nathan-k-/mqttbeat && \
cd ./mqttbeat && \
glide install && \
go build -ldflags "-linkmode external -extldflags -static" -a main.go && \
cp ./main /usr/bin/mqttbeat && \
mkdir -p /etc/default/ && \
cp ./fields.yml /etc/default/fields.yml && \
cp ./mqttbeat.yml /etc/default/mqttbeat.yml && \
apk del g++ glide git && rm -rf /go && rm -rf /root/.glide 
RUN addgroup -g 1000 -S mqttbeat && adduser -u 1000 -S mqttbeat -G mqttbeat 
RUN mkdir -p /etc/mqttbeat 
RUN chown -R mqttbeat:mqttbeat /etc/mqttbeat

ADD ./mqttbeat.yml /etc/default/mqttbeat.yml
ADD ./fields.yml /go/fields.yml
ADD ./entrypoint.sh /etc/default/entrypoint.sh
RUN chmod +x /etc/default/entrypoint.sh 
RUN chown mqttbeat:mqttbeat /etc/default/entrypoint.sh

USER mqttbeat
WORKDIR /etc/mqttbeat/
VOLUME ["/etc/mqttbeat"]
ENTRYPOINT ["/etc/default/entrypoint.sh"]
CMD ["mqttbeat", "-c", "/etc/mqttbeat/mqttbeat.yml", "-e", "-d", "*"]
