# Dockerfile for LemonLDAP::NG
# Use debian repo of LemonLDAP::NG project

# Start from Debian Jessie
FROM debian:latest
MAINTAINER Tom - Chaplean <tom@chaplean.com>

# Update system
RUN apt-get -y update \
    && apt-get -y dist-upgrade \
    && apt-get -y install \
        apt-transport-https \
        gnupg \
        wget

# Install LemonLDAP::NG repo
ADD lemonldap-ng.list /etc/apt/sources.list.d/
RUN wget -O - http://lemonldap-ng.org/_media/rpm-gpg-key-ow2 | apt-key add - \
    && apt-get -y update \
    && apt-get -y dist-upgrade \
    && apt-get -y install \
        apache2 \
        libapache2-mod-perl2 \
        libapache2-mod-fcgid \
		libio-string-perl \
        lemonldap-ng

# Change SSO DOMAIN here
ONBUILD ARG SSODOMAIN

# Change SSO Domain
ONBUILD ADD lmConf-1.json /var/lib/lemonldap-ng/conf/
ONBUILD RUN chown root:www-data /var/lib/lemonldap-ng/conf/lmConf-1.json
ONBUILD RUN sed -i "s/example\.com/$SSODOMAIN/g" /etc/lemonldap-ng/* /var/lib/lemonldap-ng/conf/lmConf-1.json /var/lib/lemonldap-ng/test/index.pl

# Enable sites
RUN a2ensite handler-apache2.conf
RUN a2ensite portal-apache2.conf
RUN a2ensite manager-apache2.conf

RUN a2enmod fcgid perl alias rewrite headers

# Remove cached configuration
RUN rm -rf /tmp/lemonldap-ng-config

EXPOSE 80 443
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
