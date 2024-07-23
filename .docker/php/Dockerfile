### Base Image Build ###
FROM php:8.2.2-fpm AS base
WORKDIR /app
RUN echo "Australia/Brisbane" >/etc/timezone && dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  libssl-dev libcurl4-openssl-dev libjpeg-dev libwebp-dev libpng-dev libzip-dev libfontconfig libxml2-dev libxrender1 libxtst6 libfreetype6-dev libxtst6 curl wkhtmltopdf wget \
  && apt-get clean && rm -rf /var/lib/apt/lists/* \
  && ln -s /usr/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf \
  && mkdir -p /etc/ssl/certs \
  && wget https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem -O /etc/ssl/certs/rds-combined-ca-bundle.pem \
  && chmod 664 /etc/ssl/certs/rds-combined-ca-bundle.pem

RUN pecl install redis \
  && docker-php-ext-configure gd --with-freetype --with-webp --with-jpeg \
  && docker-php-ext-install pdo_mysql gd zip soap xml \
  && docker-php-ext-enable opcache redis pdo_mysql gd

### Only for Production ###
FROM base AS application

WORKDIR /app
COPY . /app

ADD .docker/php/conf $PHP_INI_DIR/conf.d

RUN chgrp -R www-data /app/storage /app/bootstrap/cache /app/vendor \
  && chmod -R ug+rwx /app/storage /app/bootstrap/cache /app/vendor

ENTRYPOINT ["php-fpm"]
