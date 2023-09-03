FROM debian:buster

RUN apt update
RUN apt install -y wget \
	curl \
	bash \
	php \
	php-cgi \
	php-mysql \
	php-fpm \
	php-pdo \
	php-gd php-cli \
	php-mbstring

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf    /etc/php/7.3/fpm/pool.d

RUN mkdir -p /var/www/html
# COPY ./conf/index.php	/var/www/html/index.php

RUN mkdir /run/php

COPY ./tools/wordpress.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/wordpress.sh
RUN /usr/local/bin/wordpress.sh

ENTRYPOINT ["/usr/local/bin/wordpress.sh"]

RUN touch /var/log/fpm-php.www.log && chmod 666 /var/log/fpm-php.www.log
RUN ln -sf /dev/stderr /var/log/fpm-php.www.log

RUN touch /var/log/fpm-php.www.access.log && chmod 666 /var/log/fpm-php.www.access.log
RUN ln -sf /dev/stdout /var/log/fpm-php.www.access.log

WORKDIR /var/www/html

EXPOSE 9000

CMD ["/usr/sbin/php-fpm7.3", "-F"]