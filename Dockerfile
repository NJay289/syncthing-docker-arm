ARG GOVERSION=latest
FROM golang:$GOVERSION AS builder

WORKDIR /git
RUN git clone --depth 1 --branch v1.9.0 https://github.com/syncthing/syncthing.git
WORKDIR /src
RUN cp -r /git/syncthing/. .

ENV CGO_ENABLED=0
ENV BUILD_USER=docker
RUN rm -f syncthing && env GOOS=linux GOARCH=arm go run build.go -no-upgrade build syncthing

FROM alpine

EXPOSE 8384 22000 21027/udp

VOLUME ["/var/syncthing"]

RUN apk add --no-cache ca-certificates su-exec tzdata

COPY --from=builder /src/syncthing /bin/syncthing
COPY --from=builder /src/script/docker-entrypoint.sh /bin/entrypoint.sh

ENV PUID=1000 PGID=1000 HOME=/var/syncthing

HEALTHCHECK --interval=1m --timeout=10s \
  CMD nc -z 127.0.0.1 8384 || exit 1

ENV STGUIADDRESS=0.0.0.0:8384
ENTRYPOINT ["/bin/entrypoint.sh", "/bin/syncthing", "-home", "/var/syncthing/config"]
