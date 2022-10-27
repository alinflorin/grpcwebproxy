FROM golang AS builder
RUN apt-get update
RUN apt-get install git -y
WORKDIR /app
RUN git clone https://github.com/improbable-eng/grpc-web.git
WORKDIR /app/grpc-web/go/grpcwebproxy
RUN go build

FROM debian:buster AS runner
ENV DEBIAN_FRONTEND noninteractive
RUN mkdir -p /app
WORKDIR /app
COPY --from=builder /app/grpc-web/go/grpcwebproxy/grpcwebproxy /app/grpcwebproxy.sh
RUN chmod +x /app/grpcwebproxy.sh
ENTRYPOINT [ "/app/grpcwebproxy.sh" ]