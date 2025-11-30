FROM php:8.2-apache

RUN apt-get update && \
    apt-get install -y libmariadb-dev git unzip && \
    docker-php-ext-install pdo pdo_mysql

RUN a2enmod rewrite

WORKDIR /var/www/html

# Download and unpack EspoCRM release
RUN curl -fSL https://github.com/espocrm/espocrm/releases/download/9.2.5/EspoCRM-9.2.5.zip -o EspoCRM.zip && \
    unzip EspoCRM.zip -d /usr/src && \
    mv /usr/src/EspoCRM-9.2.5/* . && \
    rm -rf EspoCRM.zip /usr/src/EspoCRM-9.2.5

RUN chown -R www-data:www-data /var/www/html && \
    find . -type f -exec chmod 644 {} \; && \
    find . -type d -exec chmod 755 {} \;

RUN mkdir -p ./data/upload ./data/logs ./data/cache

EXPOSE 80
