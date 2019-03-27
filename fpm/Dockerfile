ARG VERSION=latest
FROM php:${VERSION}-fpm-alpine
ARG XDEBUG
ARG PHP_EXTENSIONS

# Install dependencies
RUN apk add --no-cache \
    mysql-client \
    freetype-dev libjpeg-turbo-dev \
    libpng-dev icu-dev  libpng-dev \
    libmcrypt-dev libxslt-dev libzip-dev \
    ssmtp procps && \
  docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ && \
  docker-php-ext-install -j$(nproc) $PHP_EXTENSIONS && \
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN if [ "$XDEBUG" = "1" ]; then apk add --no-cache $PHPIZE_DEPS && pecl install -o -f xdebug && docker-php-ext-enable xdebug; fi

RUN adduser -D -g 1000 -u 1000 -h /var/www -s /bin/bash app && \
  mkdir -p /var/www/html /var/www/bin && \
  chown -R app:app /var/www /var/www/html /var/www/bin

# A few sensible defaults.
ADD fpm/config/php-fpm.conf /usr/local/etc/
ADD fpm/config/opcache.ini /usr/local/etc/php/conf.d/aa-opcache.ini
RUN touch /usr/local/etc/php/conf.d/opcache.blacklist
USER app:app

WORKDIR /var/www/html

# You can add scripts into here that will be owned by app and available in your PATH.
ENV PATH /var/www/bin:$PATH

CMD ["php-fpm", "-F"]
