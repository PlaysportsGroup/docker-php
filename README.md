# playsportsgroup/php

[![CircleCI](https://circleci.com/gh/playsportsgroup/docker-php/tree/master.svg?style=svg)](https://circleci.com/gh/playsportsgroup/docker-php/tree/master)

The purpose of this is to provide a generic PHP base image that can be shared across projects. It won't matter if you're running Magento, Laravel, Wordpress, or Craft CMS, etc. You'll have a consistent base image that provides a number of tools built in, and sensible php extensions.

These images are designed to be used in production, as well as in a staging environment.

## Supported Docker image tags:

### Debian:
- playsportsgroup/php:7.3-fpm
- playsportsgroup/php:7.3-fpm-xdebug
- playsportsgroup/php:7.3-cli
- playsportsgroup/php:7.3-cli-xdebug
- playsportsgroup/php:7.4-fpm
- playsportsgroup/php:7.4-fpm-xdebug
- playsportsgroup/php:7.4-cli
- playsportsgroup/php:7.4-cli-xdebug

### Alpine:
- playsportsgroup/php:7.3-fpm-alpine
- playsportsgroup/php:7.3-fpm-xdebug-alpine
- playsportsgroup/php:7.3-cli-alpine
- playsportsgroup/php:7.3-cli-xdebug-alpine
- playsportsgroup/php:7.4-fpm-alpine
- playsportsgroup/php:7.4-fpm-xdebug-alpine
- playsportsgroup/php:7.4-cli-alpine
- playsportsgroup/php:7.4-cli-xdebug-alpine


## How to build these images locally:

You'll need to define the `PHP_VERSION` environment variable first.

    PHP_VERSION=7.4 docker-compose build

## What PHP extensions come out of the box?

apcu, opcache, dom, gd, intl, mbstring, pdo_mysql, xsl, zip, soap, bcmath, pcntl, sockets

xdebug is also installed on the specific docker images.

## What else is there?

Composer is included.

## So how can I use these images?

    docker run playsportsgroup/php:7.2-fpm $(pwd):/var/www/html -p 9000:9000 --name myawesomephpapp

Or if you like to use docker-compose:

    version: "3.0"

    services:
      cli:
        image: playsportsgroup/php:7.4-cli
        volumes:
          - ./src:/var/www/html:delegated

      phpfpm:
        image: playsportsgroup/php:7.4-fpm
        volumes:
          - ./src:/var/www/html:delegated

Then:

    docker-compose up -d

Want to run one of commands?

    docker-compose run --rm cli composer install

# OpCache

opcache is enabled by default!

For local development we recommend setting the `$PHP_OPCACHE_VALIDATE_TIMESTAMPS` environment variable to a value of `1`. For production, leave it as `0`.

    docker run -e PHP_OPCACHE_VALIDATE_TIMESTAMPS=1 playsportsgroup/php:7.2-fpm sh


## Credit

Lots of inspiration from the work on [https://github.com/meanbee/docker-magento2](meanbee/docker-magento2), and internal work completed at [Play Sports Network](https://www.playsportsnetwork.com).
