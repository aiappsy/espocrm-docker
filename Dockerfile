FROM php:8.2-apache

# Install required packages
RUN apt-get update && \
    apt-get install -y libmariadb-dev git unzip && \
    docker-php-ext-install pdo pdo_mysql

# Enable Apache rewrite module
RUN a2enmod rewrite

WORKDIR /var/www/html

# Download and unpack EspoCRM release (adjust version if needed)
RUN curl -fSL https://github.com/espocrm/espocrm/releases/download/9.2.5/EspoCRM-9.2.5.zip -o EspoCRM.zip && \
    unzip EspoCRM.zip -d /usr/src && \
    mv /usr/src/EspoCRM-9.2.5/* . && \
    rm -rf EspoCRM.zip /usr/src/EspoCRM-9.2.5

# Fix permissions for data and app files
RUN chown -R www-data:www-data /var/www/html && \
    find . -type f -exec chmod 644 {} \; && \
    find . -type d -exec chmod 755 {} \;

# Persist data directories
RUN mkdir -p ./data/upload ./data/logs ./data/cache

# Add custom Apache config for EspoCRM
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 80


# Fix permissions for mounted data directory every time the container boots
CMD ["bash", "-c", "chown -R www-data:www-data /var/www/html/data && find /var/www/html/data -type d -exec chmod 775 {} + && apache2-foreground"]
