FROM golang:1.16

WORKDIR /gotty
COPY . /gotty
RUN CGO_ENABLED=0 make

FROM alpine:latest

RUN apk update && \
    apk upgrade && \
    apk --no-cache add ca-certificates && \
    apk add bash
WORKDIR /root
COPY --from=0 /gotty/gotty /usr/bin/
# CMD ["gotty",  "-w", "bash"]
ADD ./docker_entrypoint.sh /usr/bin/docker_entrypoint.sh
RUN chmod a+x /usr/bin/docker_entrypoint.sh

# Run docker_entrypoint.sh
ENTRYPOINT ["/usr/bin/docker_entrypoint.sh"]