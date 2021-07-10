FROM golang:1.13.8 as builder
WORKDIR /go/src/github.com/influxdata/influxdb
COPY . /go/src/github.com/influxdata/influxdb
RUN go install ./cmd/...

FROM alpine
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories  
RUN apk update \
    && apk add openssl
COPY --from=builder /go/bin/* /usr/bin/
COPY --from=builder /go/src/github.com/influxdata/influxdb/etc/config.sample.toml /etc/influxdb/influxdb.conf

EXPOSE 8086
EXPOSE 6060
VOLUME /var/lib/influxdb

COPY docker/entrypoint.sh /entrypoint.sh
COPY docker/init-influxdb.sh /init-influxdb.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["influxd"]
