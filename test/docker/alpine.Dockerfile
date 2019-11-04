FROM alpine:latest
RUN apk add bash
COPY . /scripts
