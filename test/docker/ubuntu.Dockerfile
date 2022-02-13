FROM ubuntu:rolling
ENV DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC
COPY . /scripts
