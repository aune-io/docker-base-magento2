FROM php:7.3-apache

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
    unzip ssh git g++ zlib1g-dev libicu-dev libzip-dev \
    libpng-dev libjpeg-dev libxml2-dev libfreetype6-dev libxslt1-dev

# Configure GD extension to include jpeg and freetype
RUN docker-php-ext-configure gd \
#        --enable-gd-native-ttf \
        --with-freetype-dir=/usr/include/freetype2 \
        --with-png-dir=/usr/include \
        --with-jpeg-dir=/usr/include

# Enable PHP extensions
RUN docker-php-ext-install bcmath gd intl mbstring pdo pdo_mysql xml xsl soap sockets zip

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" ; \
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
