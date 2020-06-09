ARG VERSION=latest
FROM php:${VERSION}-fpm
ARG XDEBUG
ARG PHP_EXTENSIONS

ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="0" \
    PHP_OPCACHE_MAX_ACCELERATED_FILES="16000" \
    PHP_OPCACHE_MEMORY_CONSUMPTION="192" \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE="10"

# Install dependencies
RUN apt-get update -y && apt-get install -y \
    default-mysql-client \
    libfreetype6-dev libjpeg62-turbo-dev \
    libpng-dev libicu-dev  libpng-dev \
    libmcrypt-dev libxslt-dev libzip-dev procps libonig-dev \
  && apt-get install -y $PHPIZE_DEPS \
  && if [ "$VERSION" = "7.3" ]; then docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/; fi \
  && if [ "$VERSION" = "7.4" ]; then docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/; fi \
  && docker-php-ext-install -j$(nproc) ${PHP_EXTENSIONS} \
  && pecl install apcu && docker-php-ext-enable apcu \
  && if [ "$XDEBUG" = "1" ]; then pecl install -o -f xdebug && docker-php-ext-enable xdebug; fi \
  && apt-get remove -y $PHPIZE_DEPS \
  && rm -rf /var/lib/apt/lists/* \
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN mkdir -p /var/www/html /var/www/bin

# A few sensible defaults.
COPY fpm/config/php-fpm.conf /usr/local/etc/
COPY fpm/config/opcache.ini /usr/local/etc/php/conf.d/aa-opcache.ini
RUN touch /usr/local/etc/php/conf.d/opcache.blacklist

WORKDIR /var/www/html

ENV PATH /var/www/bin:$PATH

CMD ["php-fpm", "-F", "-R"]
