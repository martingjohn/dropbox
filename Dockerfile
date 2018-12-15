FROM ubuntu:bionic

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
            --no-install-recommends \
            ca-certificates \
            language-pack-en \
            python \
            rsync \
            tzdata \
            wget \
 && echo

ADD entrypoint.sh /tmp

ENV LC_ALL='en_GB.utf8'
ENV DROPBOX_UID=1000
ENV DROPBOX_GID=1000
ENV DROPBOX_HOME=/home/dropbox
ENV DROPBOX_SIZE=10
ENV PATH="$DROPBOX_HOME/.dropbox-dist:${PATH}"

CMD ["/bin/bash"]
