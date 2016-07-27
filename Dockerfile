# Dockerfile for LemonLDAP::NG
# Use debian repo of LemonLDAP::NG project

# Start from Debian Jessie
FROM debian:jessie
MAINTAINER Tom - Chaplean <tom@chaplean.com>

# Update system
RUN apt-get -y update && apt-get -y dist-upgrade

# Install LemonLDAP::NG repo
RUN apt-get -y install wget
RUN wget -O - http://lemonldap-ng.org/_media/rpm-gpg-key-ow2 | apt-key add -
ADD lemonldap-ng.list /etc/apt/sources.list.d/

# Install LemonLDAP::NG packages
RUN apt-get -y update && apt-get -y install apache2 libapache2-mod-perl2 libapache2-mod-fcgid lemonldap-ng lemonldap-ng-fr-doc

# Change SSO DOMAIN here
ONBUILD ARG SSODOMAIN

# Change SSO Domain
ONBUILD ADD lmConf-1.js /var/lib/lemonldap-ng/conf/
ONBUILD RUN sed -i "s/example\.com/$SSODOMAIN/g" /etc/lemonldap-ng/* /var/lib/lemonldap-ng/conf/lmConf-1.js /var/lib/lemonldap-ng/test/index.pl

# Enable sites
ONBUILD RUN a2ensite handler-apache2.conf
ONBUILD RUN a2ensite portal-apache2.conf
ONBUILD RUN a2ensite manager-apache2.conf

RUN a2enmod fcgid perl alias rewrite

# Remove cached configuration
RUN rm -rf /tmp/lemonldap-ng-config

EXPOSE 80 443
VOLUME ["/var/log/apache2", "/etc/apache2", "/etc/lemonldap-ng", "/var/lib/lemonldap-ng/conf", "/var/lib/lemonldap-ng/sessions", "/var/lib/lemonldap-ng/psessions"]
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
