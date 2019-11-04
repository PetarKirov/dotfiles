FROM archlinux/base
RUN pacman -Sy awk --noconfirm
COPY . /scripts
