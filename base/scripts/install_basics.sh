#!/bin/bash -eux

# https://github.com/elastic/logstash/blob/master/docker/templates/Dockerfile.j2
PACKAGE_NAME="logstash"

# create system users and folders
groupadd --gid 1000 $PACKAGE_NAME
useradd -M --uid 1000 \
    --gid 1000 \
    --home-dir /usr/share/$PACKAGE_NAME \
    --shell /bin/bash $PACKAGE_NAME
mkdir -p /usr/share/$PACKAGE_NAME
cd /usr/share/$PACKAGE_NAME

chown --recursive logstash:logstash /usr/share/logstash/ && \
chown -R logstash:root /usr/share/logstash && \
chmod -R g=u /usr/share/logstash && \
find /usr/share/logstash -type d -exec chmod g+s {} \; && \
ln -s /usr/share/logstash /opt/logstash

# set folder permissions
mkdir -p /var/log/$PACKAGE_NAME
chown -R root:$PACKAGE_NAME /var/log/$PACKAGE_NAME
chmod -R 0770 /var/log/$PACKAGE_NAME

mkdir -p /var/lib/$PACKAGE_NAME
chown -R root:$PACKAGE_NAME /var/lib/$PACKAGE_NAME
chmod -R 0770 /var/lib/$PACKAGE_NAME

chown -R root:$PACKAGE_NAME /usr/share/$PACKAGE_NAME
chmod -R 0775 /usr/share/$PACKAGE_NAME

# install the systemctl stub
cd /tmp
curl -sLO https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl.py \
  && yes | cp -f systemctl.py /usr/bin/systemctl \
  && chmod a+x /usr/bin/systemctl
