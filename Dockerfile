# Base image for running the Mikhmon v3 application with Apache and PHP-FPM.
#
# This Dockerfile uses the official `php:7.4-apache` image which bundles
# Apache HTTP Server and PHP‑FPM together. By doing so, the application
# does not need a separate Nginx or PHP-FPM service and can run as a
# single container. This simplifies deployment on platforms like Coolify
# which support Dockerfile‑based builds.
#
# To build and run this image locally, execute:
#   docker build -t mikhmonv3 .
#   docker run --rm -p 8080:80 mikhmonv3
#
# The container will serve the application on port 80. When using Coolify,
# set the exposed port to `80`.

FROM php:7.4-apache

## Install optional PHP extensions.
# The Mikhmon application primarily uses the RouterOS API and does not
# require a database by default. If you intend to connect to a database or
# enable other extensions, uncomment the relevant lines below.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libpng-dev \
        libjpeg-dev \
        libonig-dev \
        libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql mysqli \
    && rm -rf /var/lib/apt/lists/*

## Configure Apache.
# Enable the Apache rewrite module. This allows pretty URLs and route
# handling if you decide to add custom rewrites in the future.
RUN a2enmod rewrite

## Copy the application into the Apache document root.
# We copy the entire repository into `/var/www/html` which is the default
# document root for the `php:apache` images. Any additional files (e.g.
# environment configuration) should be placed alongside the source code.
COPY . /var/www/html

## Set correct file permissions.
# Ensure that the Apache user (www-data) owns the application files.
RUN chown -R www-data:www-data /var/www/html

## Expose the HTTP port. Coolify will use this to route traffic.
EXPOSE 80

## Start Apache in the foreground.
CMD ["apache2-foreground"]