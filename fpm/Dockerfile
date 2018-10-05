ARG VERSION=latest
FROM php:${VERSION}-fpm
ARG VERSION

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

# Install required PHP extensions
ADD common/install-php-extensions.sh /usr/local/bin/install-php-extensions.sh
RUN chmod +x /usr/local/bin/install-php-extensions.sh
RUN install-php-extensions.sh

# Install Xdebug (but don't enable)
RUN pecl install -o -f xdebug

# composer installed to /usr/local/bin/composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN groupadd -g 1000 app && useradd -g 1000 -u 1000 -d /var/www -s /bin/bash app

RUN mkdir -p /var/www/html /var/www/bin /var/www/entrypoint.d
RUN ["chown", "-R", "app:app", "/var/www", "/var/www/html", "/var/www/bin", "/var/www/entrypoint.d"]

# A few sensible defaults.
ADD fpm/config/www.conf /usr/local/etc/php-fpm.d/
ADD fpm/config/php-fpm.conf /usr/local/etc/
ADD common/entrypoint.sh /var/www/entrypoint.sh
RUN chmod +x /var/www/entrypoint.sh

USER app:app

# You can add scripts into here that will be owned by app and available in your PATH.
ENV PATH /var/www/bin:$PATH

ENTRYPOINT /var/www/entrypoint.sh

CMD ["php-fpm", "-F"]