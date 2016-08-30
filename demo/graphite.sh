#!/bin/sh

export DEBIAN_FRONTEND=noninteractive
# Carbon
apt-get update
apt-get --no-install-recommends install -y graphite-carbon
systemctl start carbon-cache.service

# Graphite-Web
apt-get --no-install-recommends install -y \
    graphite-web apache2 libapache2-mod-wsgi

ln -sf /usr/share/graphite-web/apache2-graphite.conf \
    /etc/apache2/sites-available/100-graphite.conf

a2dissite 000-default && a2ensite 100-graphite 

sudo -u _graphite graphite-manage syncdb --noinput 

systemctl restart apache2.service
