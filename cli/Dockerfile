ARG VERSION=latest
FROM php:${VERSION}-cli
ARG PHP_EXTENSIONS
ARG XDEBUG

ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="0" \
    PHP_OPCACHE_MAX_ACCELERATED_FILES="16000" \
    PHP_OPCACHE_MEMORY_CONSUMPTION="192" \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE="10" \
    VERSION=${VERSION}

# Install dependencies
RUN apt-get update -y && apt-get install -y \
    vim git openssh-client zip wget ca-certificates \
    default-mysql-client bash \
    libfreetype6-dev libjpeg62-turbo-dev \
    libpng-dev libicu-dev  libpng-dev \
    libmcrypt-dev libxslt-dev libzip-dev \
    procps git-crypt libonig-dev \
  && apt-get install -y $PHPIZE_DEPS \
  && if [ "$VERSION" = "7.3" ]; then docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/; fi \
  && if [ "$VERSION" = "7.4" ]; then docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/; fi \
  && docker-php-ext-install -j$(nproc) ${PHP_EXTENSIONS} \
  && pecl install apcu && docker-php-ext-enable apcu \
  && if [ "$XDEBUG" = "1" ]; then pecl install -o -f xdebug && docker-php-ext-enable xdebug; fi \
  && apt-get remove -y $PHPIZE_DEPS \
  && rm -rf /var/lib/apt/lists/* \
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY fpm/config/opcache.ini /usr/local/etc/php/conf.d/aa-opcache.ini

# Install dockerize
RUN DOCKERIZE_URL="https://circle-downloads.s3.amazonaws.com/circleci-images/cache/linux-amd64/dockerize-latest.tar.gz" \
  && curl --silent --show-error --location --fail --retry 3 --output /tmp/dockerize-linux-amd64.tar.gz $DOCKERIZE_URL \
  && tar -C /usr/local/bin -xzvf /tmp/dockerize-linux-amd64.tar.gz \
  && rm -rf /tmp/dockerize-linux-amd64.tar.gz \
  && dockerize --version

RUN mkdir -p /var/www/html /var/www/bin

WORKDIR /var/www/html
ENV PATH /var/www/bin:$PATH
