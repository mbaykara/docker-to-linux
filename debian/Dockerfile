FROM debian:stretch

RUN apt-get -y update
RUN apt-get -y install --no-install-recommends \
  linux-image-amd64 \
  systemd-sysv  extlinux

RUN echo "root:root" | chpasswd

