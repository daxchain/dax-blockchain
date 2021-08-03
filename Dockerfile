FROM golang:1.12-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git

ADD . /tomochain
RUN cd /tomochain && make dax

FROM alpine:latest

WORKDIR /tomochain

COPY --from=builder /tomochain/build/bin/dax /usr/local/bin/dax

RUN chmod +x /usr/local/bin/dax

EXPOSE 8545
EXPOSE 30303

ENTRYPOINT ["/usr/local/bin/dax"]

CMD ["--help"]
