ARG VERSION=latest
FROM php:${VERSION}-cli-alpine
ARG PHP_EXTENSIONS
ARG XDEBUG

# Install dependencies
RUN apk add --no-cache \
    vim git zip wget \
    mysql-client \
    freetype-dev libjpeg-turbo-dev \
    libpng-dev icu-dev  libpng-dev \
    libmcrypt-dev libxslt-dev libzip-dev \
    ssmtp  procps && \
  docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
  docker-php-ext-install $PHP_EXTENSIONS && \
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN if [ "$XDEBUG" = "1" ]; then apk add --no-cache $PHPIZE_DEPS && pecl install -o -f xdebug && docker-php-ext-enable xdebug; fi

# Install dockerize
RUN DOCKERIZE_URL="https://circle-downloads.s3.amazonaws.com/circleci-images/cache/linux-amd64/dockerize-latest.tar.gz" \
  && curl --silent --show-error --location --fail --retry 3 --output /tmp/dockerize-linux-amd64.tar.gz $DOCKERIZE_URL \
  && tar -C /usr/local/bin -xzvf /tmp/dockerize-linux-amd64.tar.gz \
  && rm -rf /tmp/dockerize-linux-amd64.tar.gz \
  && dockerize --version

RUN adduser -D -g 1000 -u 1000 -h /var/www -s /bin/bash app && \
  mkdir -p /var/www/html /var/www/bin && \
  chown -R app:app /var/www /var/www/html /var/www/bin

USER app:app
WORKDIR /var/www/html
ENV PATH /var/www/bin:$PATH
