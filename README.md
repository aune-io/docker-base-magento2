# docker-base-magento2
Base image for a container running Magento 2

[![](https://images.microbadger.com/badges/image/aune/magento2.svg)](http://microbadger.com/images/aune/magento2)
[![](https://images.microbadger.com/badges/version/aune/magento2.svg)](http://microbadger.com/images/aune/magento2)
[![](https://images.microbadger.com/badges/commit/aune/magento2.svg)](http://microbadger.com/images/aune/magento2)

## Features
* Based on the official `php:7.3-apache`
* Enables Apache mod_rewrite
* Installs all PHP dependencies
* Sets `/var/www/html/pub` as Apache root

## Usage
Copy your application code under `/var/www/html`, so that the public folder `/var/www/html/pub` is served by Apache.
