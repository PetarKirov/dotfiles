FROM archlinux:base
RUN pacman -Syu awk --noconfirm
COPY . /scripts
