FROM linuxbrew/linuxbrew
ENV OS=osx DIST=linuxbrew
RUN brew update-reset
COPY . /scripts
