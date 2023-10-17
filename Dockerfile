FROM golang:1.21.3 as builder
WORKDIR /go/src/github.com/influxdata/influxdb
COPY . /go/src/github.com/influxdata/influxdb
RUN go mod tidy
RUN go install ./cmd/...

FROM alpine
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories  
RUN apk update \
    && apk add openssl curl \
	&& apk add --no-cache bash \
        bash-doc \
        bash-completion \
	&& apk add tzdata \
    && rm -rf /var/cache/apk/* \
    && /bin/bash
RUN apk upgrade
RUN mkdir /lib64
RUN ln -s /lib/ld-musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
COPY --from=builder /go/bin/* /usr/bin/
COPY --from=builder /go/src/github.com/influxdata/influxdb/etc/config.sample.toml /etc/influxdb/influxdb.conf

EXPOSE 8086
EXPOSE 6060
VOLUME /var/lib/influxdb

COPY docker/entrypoint.sh /entrypoint.sh
COPY docker/init-influxdb.sh /init-influxdb.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["influxd"]
