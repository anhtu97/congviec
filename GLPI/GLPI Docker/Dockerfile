FROM centos:7
MAINTAINER Bin <tmtdtuctf@gmail.com>
RUN yum -y update
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
	http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
	yum-utils 
RUN yum-config-manager --enable remi-php72
RUN yum -y install php \
	php-mcrypt \
	php-cli \
	php-gd \
	php-curl \
	php-mysql \
	php-ldap \
	php-zip \
	php-fileinfo \
	php-imap \
	php-pear \
	php-devel \
	httpd-devel \
	pcre-devel \
	gcc \
	make \
	php-pecl-apcu \
	php-xmlrpc \
	httpd \
	php \
	php-mysql \
	php-pdo \
	php-gd \
	php-mbstring \
	php-imap \
	php-ldap

COPY start.sh /opt/
RUN chmod +x /opt/start.sh
WORKDIR /var/www/html

CMD /opt/start.sh
