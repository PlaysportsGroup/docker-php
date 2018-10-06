ARG VERSION=latest
FROM php:${VERSION}-cli
ARG PHP_EXTENSIONS

# Install dependencies
RUN apt-get update \
  && apt-get install -y \
    vim \
    git \
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
    ssmtp

# Configure the gd library
RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Configure postgresql
RUN docker-php-ext-configure \
  pgsql -with-pgsql=/usr/local/pgsql

RUN php -i | grep -e "Loaded Configuration File" -e "Scan this dir for additional .ini files" -e "Additional .ini files parsed"

# Install required PHP extensions
RUN docker-php-ext-install $PHP_EXTENSIONS

# Install Xdebug (but don't enable)
RUN pecl install -o -f xdebug

# composer installed to /usr/local/bin/composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN groupadd -g 1000 app && useradd -g 1000 -u 1000 -d /var/www -s /bin/bash app

RUN mkdir -p /var/www/html /var/www/bin
RUN ["chown", "-R", "app:app", "/var/www", "/var/www/html", "/var/www/bin"]

USER app:app

# You can add scripts into here that will be owned by app and available in your PATH.
ENV PATH /var/www/bin:$PATH
