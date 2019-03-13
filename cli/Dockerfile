ARG VERSION=latest
FROM php:${VERSION}-cli
ARG PHP_EXTENSIONS

# Install dependencies
RUN apt-get update \
  && apt-get install -y \
    vim \
    git \
    git-crypt \
    zip \
    mysql-client \
    wget \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxslt1-dev \
    libpq-dev \
    ssmtp \
    procps

# Configure the gd library
RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Configure postgresql
RUN docker-php-ext-configure \
  pgsql -with-pgsql=/usr/local/pgsql

# Install required PHP extensions
RUN docker-php-ext-install $PHP_EXTENSIONS

# Install Xdebug (but don't enable)
RUN pecl install -o -f xdebug

# composer installed to /usr/local/bin/composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dockerize
RUN DOCKERIZE_URL="https://circle-downloads.s3.amazonaws.com/circleci-images/cache/linux-amd64/dockerize-latest.tar.gz" \
  && curl --silent --show-error --location --fail --retry 3 --output /tmp/dockerize-linux-amd64.tar.gz $DOCKERIZE_URL \
  && tar -C /usr/local/bin -xzvf /tmp/dockerize-linux-amd64.tar.gz \
  && rm -rf /tmp/dockerize-linux-amd64.tar.gz \
  && dockerize --version

RUN groupadd -g 1000 app && useradd -g 1000 -u 1000 -d /var/www -s /bin/bash app

RUN mkdir -p /var/www/html /var/www/bin
RUN ["chown", "-R", "app:app", "/var/www", "/var/www/html", "/var/www/bin"]

USER app:app

WORKDIR /var/www/html

# You can add scripts into here that will be owned by app and available in your PATH.
ENV PATH /var/www/bin:$PATH
