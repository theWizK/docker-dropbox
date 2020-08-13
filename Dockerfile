FROM debian:buster-slim
LABEL maintainer Kendal Montgomery <kmontgomery@clarivoy.com>
ENV DEBIAN_FRONTEND noninteractive
ENV LC_CTYPE en_US.UTF-8
ENV LANG C.UTF-8

# Following 'How do I add or remove Dropbox from my Linux repository?' - https://www.dropbox.com/en/help/246
RUN apt-get -y update \
    # Note 'ca-certificates' dependency is required for 'dropbox start -i' to succeed
    && apt-get -qqy install ca-certificates curl wget python3 \
      libglib2.0-bin libxext6 libglapi-mesa libxdamage1 libxcb-glx0 \
      libxcb-dri2-0 libxcb-dri3-0 libxcb-present0 libxcb-sync1 \
      libxxf86vm1 libxshmfence1 \
    # Perform image clean up.
    && apt-get -qqy autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    # Create service account and set permissions.
    && groupadd dropbox \
    && useradd -m -d /dbox -c "Dropbox Daemon Account" -s /usr/sbin/nologin -g dropbox dropbox \
    # Download / install
    && echo Downloading and unpacking dropbox... \
    && mkdir -p /dbox && cd /dbox  && wget --quiet -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf - \
    && chown -R dropbox:dropbox /dbox \
    && mkdir -p /opt/dropbox \
    # Prevent dropbox to overwrite its binary
    && mv /dbox/.dropbox-dist/dropbox-lnx* /opt/dropbox/ \
    && mv /dbox/.dropbox-dist/dropboxd /opt/dropbox/ \
    && mv /dbox/.dropbox-dist/VERSION /opt/dropbox/ \
    && rm -rf /dbox/.dropbox-dist \
    && install -dm0 /dbox/.dropbox-dist \
    # Prevent dropbox to write update files
    && chmod u-w /dbox \
    && chmod o-w /tmp \
    && chmod g-w /tmp \
    && ln -s /dbox /home/dropbox

# Install init script and dropbox command line wrapper
ADD run /root/
ADD dropbox /usr/bin/dropbox

WORKDIR /dbox/Dropbox
EXPOSE 17500
VOLUME ["/dbox/.dropbox", "/dbox/Dropbox"]
ENTRYPOINT ["/root/run"]
