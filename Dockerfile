FROM php:7.1-apache

# Enable apache mod_rewrite
RUN a2enmod rewrite

# Change document root
ENV APACHE_DOCUMENT_ROOT /var/www/html/pub
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Install dependencies
ENV BUILD_DEPS="zlib1g-dev libicu-dev g++"
ENV LIB_DEPS="libpng-dev libmcrypt-dev libxml2-dev libfreetype6-dev libxslt1-dev"
RUN apt-get update && apt-get install -y --no-install-recommends $BUILD_DEPS $LIB_DEPS

# Enable mysql extension
RUN docker-php-ext-install bcmath gd intl mbstring mcrypt pdo pdo_mysql xml xsl soap zip

# Purge apt dependencies
RUN apt-get purge -y --auto-remove $BUILD_DEPS

# Image metadata
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Magento 2 base image" \
      org.label-schema.description="Base image for a containerized Magento 2 environment." \
      org.label-schema.url="https://github.com/aune-io/docker-base-magento2/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/aune-io/docker-base-magento2/" \
      org.label-schema.vendor="Aune Limited" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"
