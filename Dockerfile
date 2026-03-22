FROM node:22-bookworm-slim AS js-build
WORKDIR /gotty
COPY js /gotty/js
COPY Makefile /gotty/
RUN make bindata/static/js/gotty.js.map

FROM golang:1.23 as go-build
WORKDIR /gotty
COPY . /gotty
COPY --from=js-build /gotty/js/node_modules /gotty/js/node_modules
COPY --from=js-build /gotty/bindata/static/js /gotty/bindata/static/js
RUN CGO_ENABLED=0 make

FROM debian:bookworm-slim
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends ca-certificates bash htop yq jq screen && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root
COPY --from=go-build /gotty/gotty /usr/bin/
CMD ["gotty",  "-w", "bash"]
