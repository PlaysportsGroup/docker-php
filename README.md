# ashsmith/php

[![CircleCI](https://circleci.com/gh/ashsmith/docker-php/tree/master.svg?style=svg)](https://circleci.com/gh/ashsmith/docker-php/tree/master)

The purpose of this is to provide a generic PHP base image that can be shared across projects. It won't matter if you're running Magento, Laravel, Wordpress, or Craft CMS, etc. You'll have a consistent base image that provides a number of tools built in, and sensible php extensions.

These images are designed to be used in production, as well as in a staging environment.

Available tags:

- 7.1-fpm
- 7.1-cli
- 7.2-fpm
- 7.2-cli

## How to build these images locally:

    docker-compose build

## How to add additional packages in your own dockerfile:

You will need to reconfigure to use the `root` user, then switch back afterwards to the `app` user.

    FROM ashsmith/php:7.2-fpm

    USER root
    RUN apt-get update && apt-get install myawesomepackage -y
    USER app:app

## What PHP extensions come out of the box?

- xdebug (but it's disabled, you'll need to enable it manually!)
- gd
- intl
- mbstring
- pdo_mysql
- pdo_pgsql
- xsl
- zip
- soap
- bcmath
- mcrypt
- pcntl

My goal is to provide some commonly used extensions, and speed up build times by not needing to recompile PHP multiple times.

## What else is there?

Composer, of course!

## Why do you use an `app` user instead of root?

TL;DR; Security.

Read up on it here: [Processes in containers should not run as root](https://medium.com/@mccode/processes-in-containers-should-not-run-as-root-2feae3f0df3b)

## So how can I use this!?

    docker run ashsmith/php:7.2-fpm -v $(pwd):/var/www/html -p 9000:9000 --name myawesomephpapp

Or if you like to use docker-compose:

    version: "3.0"

    services:
      cli:
        image: ashsmith/php:7.2-cli
        volumes:
          - ./src:/var/www/html:delegated

      phpfpm:
        image: ashsmith/php:7.2-fpm
        volumes:
          - ./src:/var/www/html:delegated

      nginx:
        image: ashsmith/nginx:latest-phpfpm
        environment:
          - FPM_HOST=phpfpm
        links:
          - phpfpm
        ports:
          - 80:80
        volumes:
          - ./src:/var/www/html:delegated

Then:

    docker-compose up -d

Want to run one of commands?

    docker-compose run --rm cli composer install

# OpCache

opcache is enabled by default!

For local development I recommend mounting a new php .ini file to disable opcache.


## Credit

Lots of inspiration from the work on [https://github.com/meanbee/docker-magento2](meanbee/docker-magento2), and internal work I have completed at [Play Sports Network](https://www.playsportsnetwork.com).
