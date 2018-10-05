#!/bin/bash

EXTENSIONS="gd intl mbstring pdo_mysql pdo_pgsql xsl zip soap bcmath pcntl"

# Only install mcrypt in 7.1
if ["${VERSION}" == "7.1"]
then
  EXTENSIONS="${EXTENSIONS} mcrypt"
fi

docker-php-ext-install $EXTENSIONS