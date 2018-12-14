FROM php:7.2-apache

# Enable apache mod_rewrite
RUN a2enmod rewrite

# Change document root
ENV APACHE_DOCUMENT_ROOT /var/www/html/pub

# Copy Apache configuration for VirtualHost
COPY config/000-default.conf /etc/apache2/sites-available/000-default.conf

# Apply production PHP configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Add opcache configuration
COPY config/10-opcache.ini "$PHP_INI_DIR/conf.d/"

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    g++ zlib1g-dev libicu-dev \
    libpng-dev libjpeg-dev libmcrypt-dev libxml2-dev libfreetype6-dev libxslt1-dev

# Enable mysql extension
RUN docker-php-ext-install bcmath gd intl mbstring mcrypt pdo pdo_mysql xml xsl soap zip

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" ; \
    php -r "if (hash_file('sha384', 'composer-setup.php') === '93b54496392c062774670ac18b134c3b3a95e5a5e5c8f1a9f115f203b75bf9a129d5daa8ba6a13e2cc8a1da0806388a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" ; \
    php composer-setup.php ; \
    php -r "unlink('composer-setup.php');" ; \
    chmod +x composer.phar ; \
    mv composer.phar /usr/local/bin/composer

# Install n98-magerun2
RUN curl -O https://files.magerun.net/n98-magerun2.phar ; \
    chmod +x n98-magerun2.phar ; \
    mv n98-magerun2.phar /usr/local/bin/n98-magerun2

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
